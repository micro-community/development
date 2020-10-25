# Model

The model provides a simple crud abstraction data modelling layer on top of the store.

## Overview

The store provides basic key-value storage with some additions but this isn't sufficient for crud based operation. We need something that provides 
higher level functionality in the rails did. Rails promoted the model-view-controller (MVC) whereas in micro we want to promote client-server-model (CSM). 
In this case, a model is fairly important to our requirements for not only calling/handling requests but also persisting data.

## Rationale

The querying capabilities of simple key-value stores can be extended by saving the data in a way that will enable querying with a specifc query in mind.
Ie. let's say we want to list all object where the field `A` equals to `15`:

```sh
{
    "ID": "1",
    "A": 15,
}
{
    "ID": "2",
    "A": 30,
}
{
    "ID": "3",
    "A": 30,
}
```

It is easy to see that we can save the objects under the following keys:

```sh
# keys. structure:
# indexPrefix : field value : record id
byA:15:1
byA:30:2
byA:30:3
```

After the key is organized this way, it is trivial to `Read` all records where the field value is `A`.

The thing gets complicated once we try to mantain many of these indexes. Or combine that with ordering of result sets, for example blog posts needing to be stored in reverse chronological order.

The following examples were taken out of the blog [posts service](https://github.com/micro/services/blob/master/blog/posts/handler/posts.go):


```go
const (
	slugPrefix      = "slug"
	idPrefix        = "id"
	timeStampPrefix = "timestamp"
)

err = store.Write(&store.Record{
	Key:   fmt.Sprintf("%v:%v", idPrefix, post.ID),
	Value: bytes,
})

err = store.Write(&store.Record{
	Key:   fmt.Sprintf("%v:%v", slugPrefix, post.Slug),
	Value: bytes,
})

// MaxInt64 piece is there to suppport reverse chronological ordering
err = store.Write(&store.Record{
	Key:   fmt.Sprintf("%v:%v", timeStampPrefix, math.MaxInt64-post.CreateTimestamp),
	Value: bytes,
})
```

Similarly, studying relevant parts of the [tags service](https://github.com/micro/services/blob/master/blog/tags/handler/tags.go) shows:

```go
const (
	slugPrefix     = "bySlug"
	resourcePrefix = "byResource"
	typePrefix     = "byType"
	tagCountPrefix = "tagCount"
	childrenByTag  = "childrenByTag"
)

// increase tag count
err = store.Write(&store.Record{
	Key:   fmt.Sprintf("%v:%v:%v", tagCountPrefix, tag.Slug, req.GetResourceID()),
	Value: nil,
})
    
// get tag count
recs, err := store.List(store.Prefix(fmt.Sprintf("%v:%v", tagCountPrefix, tag.Slug)), store.Limit(1000))
if err != nil {
	return err
}

err = store.Write(&store.Record{
	Key:   fmt.Sprintf("%v:%v:%v", resourcePrefix, req.GetResourceID(), tag.Slug),
	Value: tagJSON,
})}

key := fmt.Sprintf("%v:%v", slugPrefix, tagSlug)
typeKey := fmt.Sprintf("%v:%v:%v", typePrefix, tag.Type, tagSlug)
```

Here, an additional requirement popped up: maintaining counters for the number of distinct values in a set.

## Design

Abstract out common indexing and query pattern to a library on top of the Store.
This library will only use the Store for persistence. Save differnet required indexes under different prefixes and maintain these automatically.

We could either give different indexes with different query characteristics their separate type signature like [gocassa](github.com/gocassa/gocassa) does it, and gain some level of type safety at the sacrifice of convenience and elegance or we could specify future query requirements in a constructor and throw an runtime error (runtime as in not compile time) if an unexpected query (one that has no prebuilt index) happens. The former has gocassa as an example, so I will only outline the latter below (which is my preferred solution nowadays anyway - unlike when I wrote gocassa).

### Interface


```go
type ModelDB interface {
    Save(interface{}) error
    List(Query) ([]interface, error)
}

func NewModelDB(store store.Store, entity interface{}, []Index) ModelDB

type Index struct {
    FieldName string
    Type string // eg. equality
    Ordering bool // ASC or DESC ordering
}

func By(fieldName string) Index

type Query {
    Type string
    FieldName string
    Value interface{}
}

func Eq(fieldName string, value interface{}) Query
```

Perhaps Index and Query can be reduced to one type, but I suspect they should be separate, later there will be index specific things ie. bucketing etc.

### Usage

```sh
import github.com/micro/dev/model

type Tag struct {
	Title string `json:"title"`
	Slug  string `json:"slug"`
	Type  string `json:"type"`
	Count int64  `json:"count"`
}

var db = model.New(store, Tag{}, model.By("slug"), model.By("type"))

err := db.Save(Tag{
    Title: "Finance",
})

res, err := db.List(Eq("type", "post-tag"))
```

