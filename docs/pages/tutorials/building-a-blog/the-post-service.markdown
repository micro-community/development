---
layout: page
title: The Post Service
keywords: tutorials
tags: [building-a-blog]
sidebar: home_sidebar
toc_list: false
nav_order: 1
parent: Building A Blog
grand_parent: Tutorials
permalink: /the-post-service
---

# The Post Service
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

In this post we will build a post service. It will a good way to learn how to build nontrivial applications with the [Key-Value Store interface](/getting-started#storage).

The most important takeaway from this post will likely be the the usage of the key-value store for non-trivial usecases (querying blog posts by slug and listing them by reverse creation order).

## The Basics

So where to start? In the [Getting Started guide](/getting-started) we already covered [creating a service](/getting-started#creating-a-service).

Let's use that knowledge!
As a reminder, we have to make sure `micro server` is running in an other terminal, and we are connected to it, ie

```
$ micro env
  local                             none
* server                            127.0.0.1:8081
  platform                          proxy.m3o.com
```

has the server environment picked. If not, we can issue `micro env set server` to remedy.   

Now back to the `micro new` command:

```
$ micro new post
$ ls post
Dockerfile  generate.go  go.mod  handler  main.go  Makefile  plugin.go  proto  README.md  subscriber
```

Great! The best way to start a service is to define the proto. The generated default should be something similar to this:

```sh
$ cd post; # step into project root
$ cat proto/post/post.proto 
syntax = "proto3";

package go.micro.service.posts;

service Posts {
	rpc Call(Request) returns (Response) {}
    // some more methods here...
}

message Message {
	string say = 1;
}

message Request {
	string name = 1;
}

message Response {
	string msg = 1;
}

// some more types here...
```

In our post service, we want 3 methods:
- `Post` for blog post insert and update
- `Query` for reading and listing
- `Delete` for deletion

Let's start with the post method. Modify our `proto/post/post.proto` file to match the following:

<a name="posts-proto"></a>
```proto
syntax = "proto3";

package go.micro.service.post;

service Posts {
	rpc Post(PostRequest) returns (PostResponse) {}
}

message Post {
	string id = 1;
	string title = 2;
	string slug = 3;
	string content = 4;
	int64 timestamp = 5;
	repeated string tagNames = 6;
}
message PostRequest {
	Post post = 1;
}

message PostResponse {
	Post post = 1;
}
```

To regenerate the proto, we have to issue the `make proto` command in the project root.
Let's adjust the handler to match our proto!

```go
package handler

import (
    "context"

	"github.com/micro/go-micro/v2/client"
	log "github.com/micro/go-micro/v2/logger"
	"github.com/micro/go-micro/v2/store"

	post "github.com/micro/examples/blog/post/proto/post"
)

type Posts struct {
	Store  store.Store
	Client client.Client
}

func (t *Posts) Post(ctx context.Context, req *post.PostRequest, rsp *post.PostResponse) error {
    log.Info("Received Posts.Post request")
    return nil
}
```

Now, the `main.go`:

```go
package main

import (
	"github.com/micro/examples/blog/posts/handler"
	"github.com/micro/examples/blog/posts/subscriber"
	"github.com/micro/go-micro/v2"

	log "github.com/micro/go-micro/v2/logger"
	posts "github.com/micro/examples/blog/posts/proto/posts"
)

func main() {
	// New Service
	service := micro.NewService(
		micro.Name("go.micro.service.posts"),
		micro.Version("latest"),
	)

	// Initialise service
	service.Init()

	// Register Handler
	post.RegisterPostsHandler(service.Server(), &handler.Posts{
		Store:  service.Options().Store,
		Client: service.Client(),
	})

	// Register Struct as Subscriber
	micro.RegisterSubscriber("go.micro.service.posts", service.Server(), new(subscriber.Posts))

	// Run service
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
```

At this point `micro run .` in project root should deploy our post service. Let's verify with `micro logs blog/posts`:

```
$ micro logs blog/posts
Auth [service] Authenticated as go.micro.service.posts-b6c818ad-c5b3-44de-949b-2a1cbfee4d04 issued by go.micro
Starting [service] go.micro.service.posts
Server [grpc] Listening on [::]:36265
Broker [service] Connected to 127.0.0.1:8001
```

(The exact output might depend on the actual config format configuraton.)

## Saving posts

Let's make our service do something useful now: save a post.
First we define our model, the `Post` type, to match the proto:

```go
type Post struct {
	ID              string   `json:"id"`
	Title           string   `json:"title"`
	Slug            string   `json:"slug"`
	Content         string   `json:"content"`
	CreateTimestamp int64    `json:"create_timestamp"`
	UpdateTimestamp int64    `json:"update_timestamp"`
	TagNames        []string `json:"tagNames"`
}
```

After this, we modify the Post endpoint. Let's start with some basic input validation:

```go
func (t *Posts) Post(ctx context.Context, req *posts.PostRequest, rsp *posts.PostResponse) error {
	if len(req.Post.Id) == 0 || len(req.Post.Title) == 0 || len(req.Post.Content) == 0 {
		return errors.New("ID, title or content is missing")
	}

	return nil
}
```

Some defensive programming never hurts to avoid confusion down the road!
Not too exciting yet though. How about actually saving our post? To do that we need to understand how key-value stores work.
For now, let's just understand that we want to save the post under the key or keys we will use to retrieve it.
Since UUIDs are not too nice, we will use a slug generated by the `github.com/gosimple/slug` library:

(A slug is a urlified version of a title, ie. `How to Micro` becomes `how-to-micro`.)

```go
func (t *Posts) Post(ctx context.Context, req *posts.PostRequest, rsp *posts.PostResponse) error {
	if len(req.Post.Id) == 0 || len(req.Post.Title) == 0 || len(req.Post.Content) == 0 {
		return errors.New("ID, title or content is missing")
	}

	postSlug := slug.Make(req.Post.Title)
	now := time.Now().Unix()
	post := &Post{
		ID:              req.Post.Id,
		Title:           req.Post.Title,
		Content:         req.Post.Content,
		Slug:            postSlug,
		TagNames:        req.Post.TagNames,
		CreateTimestamp: now,
		UpdateTimestamp: now,
	}
	bytes, err := json.Marshal(post)
	if err != nil {
		return err
	}

	return 	t.Store.Write(&store.Record{
		Key:   postSlug,
		Value: bytes,
	})
}
```

After a `micro update .` in project root, we can start saving posts!

```
micro call go.micro.service.posts Posts.Post '{"id":"1","title":"Post one", "Content":"First saved post"}'
micro call go.micro.service.posts Posts.Post '{"id":"2","title":"Post two", "Content":"Second saved post"}'
```

WOW! We are on a roll! We've just saved two posts. There is one problem however. There is no way yet to get the posts out of the post service.
Now luckily, `micro store` commands are designed to interact with the saved data. `micro store list` will list all keys saved (but not values):

```
$ micro store list --table=go.micro.service.posts
post-one
post-two
```

Why are these keys there? Remember we saved the posts by slug. Okay, but where are the values? `micro store read` comes to our rescue:

```
$ micro store read --table=go.micro.service read post-one
{"id":"1","title":"Post one", "content":"First saved post", "create_timestamp":1591970869, "update_timestamp":1591970869}
$ micro store read --table=go.micro.service read post-two
{"id":"2","title":"Post two", "content":"Second saved post",  "create_timestamp":1591970870, "update_timestamp":1591970870}
```

It's a bit annoying however to read values one by one, that' why the `--prefix` flag exists:

```
$ micro store read --table=go.micro.service --prefix post
{"id":"1","title":"Post one", "Content":"First saved post", "create_timestamp":1591970869, "update_timestamp":1591970869}
{"id":"2","title":"Post two", "Content":"Second saved post",  "create_timestamp":1591970870, "update_timestamp":1591970870}
```

And this takes us to the most important part of this post.

## Non-trivial applications with Key-Value stores

So far we saved posts by slug, but how would we go about listing post in order?
As we have seen, listing by prefix gives us pretty much the only query capabilities in the key-value store (and in most other key value stores too, it's not specific to Micro).

So how would we go about enabling post read by slug and listing posts too?
Let's imagine the following key:

```
$ micro store list
slug:first-post
slug:second-post
timestamp:1591970869
timestamp:1591970870
```

We should also note that all records are listed in an alphabetical order of their keys.
We can exploit this, coupled with the `--offset` and `--limit` concepts to implement paging, ie.

```
micro store read --table=go.micro.service --prefix --offset 0 --limit 20 post
```

would give back the first 20 posts, 

```
micro store read --table=go.micro.service --prefix --offset 20 --limit 20 post
```

would return the second 20 posts - the second page essentially - and so on.
Same applies to our post service too as with most micro interfaces the CLI commands are 1-to-1 representations of the framework features.

Let's get to work then and modify our `Post` handler. We are going to save the post under 3 different keys: under its ID, slug and create timestamp.
While coming from an SQL background and being used to keeping the data model first normal form this might look weird, but key-value stores
can be an insanely scalable and fast way to store information.

This theoretical impurity and somewhat inconvenient way to handle data can enable us to scale our web application to unimaginable scales.
The following code piece might be a bit longer than the previous ones, but it contains many important additions, like checking for slug changes.

```go
const (
	idPrefix		= "id"
	slugPrefix 		= "slug"
	timestampPrefix = "timestamp"
)

func (t *Posts) Post(ctx context.Context, req *posts.PostRequest, rsp *posts.PostResponse) error {
	if len(req.Post.Id) == 0 || len(req.Post.Title) == 0 || len(req.Post.Content) == 0 {
		return errors.New("ID, title or content is missing")
	}

	// read by parent ID so we can check if it exists without slug changes getting in the way.
	records, err := t.Store.Read(fmt.Sprintf("%v:%v", idPrefix, req.Post.Id))
	if err != nil && err != store.ErrNotFound {
		return err
	}
	postSlug := slug.Make(req.Post.Title)

	// If no existing record is found, create a new one
	if len(records) == 0 {
		post := &Post{
			ID:              req.Post.Id,
			Title:           req.Post.Title,
			Content:         req.Post.Content,
			TagNames:        req.Post.TagNames,
			Slug:            postSlug,
			CreateTimestamp: time.Now().Unix(),
		}
		return t.savePost(ctx, nil, post)
	}

	record := records[0]
	oldPost := &Post{}
	err = json.Unmarshal(record.Value, oldPost)
	if err != nil {
		return err
	}
	post := &Post{
		ID:              req.Post.Id,
		Title:           req.Post.Title,
		Content:         req.Post.Content,
		Slug:            postSlug,
		TagNames:        req.Post.TagNames,
		CreateTimestamp: oldPost.CreateTimestamp,
		UpdateTimestamp: time.Now().Unix(),
	}

	// Check if slug exists
	recordsBySlug, err := t.Store.Read(fmt.Sprintf("%v:%v", slugPrefix, postSlug))
	if err != nil && err != store.ErrNotFound {
		return err
	}
	otherSlugPost := &Post{}
	err = json.Unmarshal(record.Value, otherSlugPost)
	if err != nil {
		return err
	}
	if len(recordsBySlug) > 0 && oldPost.ID != otherSlugPost.ID {
		return errors.New("An other post with this slug already exists")
	}

	return t.savePost(ctx, oldPost, post)
}

func (t *Posts) savePost(ctx context.Context, oldPost, post *Post) error {
	bytes, err := json.Marshal(post)
	if err != nil {
		return err
	}

	// Save post by ID
	err = t.Store.Write(&store.Record{
		Key:   fmt.Sprintf("%v:%v", idPrefix, post.ID),
		Value: bytes,
	})
	if err != nil {
		return err
	}
	// Delete old slug index if the slug has changed
	if oldPost.Slug != post.Slug {
		err = t.Store.Delete(fmt.Sprintf("%v:%v", slugPrefix, post.Slug))
		if err != nil {
			return err
		}
	}
	// Save post by slug
	err = t.Store.Write(&store.Record{
		Key:   fmt.Sprintf("%v:%v", slugPrefix, post.Slug),
		Value: bytes,
	})
	if err != nil {
		return err
	}
	// Save post by timeStamp
	return t.Store.Write(&store.Record{
		// We revert the timestamp so the order is chronologically reversed
		Key:   fmt.Sprintf("%v:%v", timeStampPrefix, math.MaxInt64-post.CreateTimestamp),
		Value: bytes,
	})
}
```

We can again invoke the Micro CLI to play around with our service after a `micro update .` in the project root.
Let's insert two posts through the service we wote:

```
micro call go.micro.service.posts Posts.Post '{"post":{"id":"1","title":"How to Micro","content":"Simply put, Micro is awesome."}}'
micro call go.micro.service.posts Posts.Post '{"post":{"id":"2","title":"Fresh posts are fresh","content":"This post is fresher than the How to Micro one"}}'
```

## Querying posts

While we can query the data through `micro store list --table=go.micro.service.posts`, we still can't do that through the service.
Implementing the `Query` handler will enable doing that, but first we need to amend and regenerate [our proto](#posts-proto). We will also define the `Delete` endpoint in this step so we don't have to touch this file again soon:

```
syntax = "proto3";

package go.micro.service.posts;

service Posts {
	// Query currently only supports read by slug or timestamp, no listing.
	rpc Query(QueryRequest) returns (QueryResponse) {}
	rpc Post(PostRequest) returns (PostResponse) {}
	rpc Delete(DeleteRequest) returns (DeleteResponse) {}
}

message Post {
	string id = 1;
	string title = 2;
	string slug = 3;
	string content = 4;
	int64 timestamp = 5;
	repeated string tagNames = 6;
}

message QueryRequest {
	string slug = 1;
	int64 offset = 2;
	int64 limit = 3;
}

message QueryResponse {
	repeated Post posts = 1;
}

message PostRequest {
	Post post = 1;
}

message PostResponse {
	Post post = 1;
}

message DeleteRequest {
	string id = 1;
}

message DeleteResponse {}

```

A `make proto` issued in the command root should regenerate the Go proto files and we should be ready to define our new handler:

```go
func (t *Posts) Query(ctx context.Context, req *post.QueryRequest, rsp *post.QueryResponse) error {
	var records []*store.Record
	var err error
	if len(req.Slug) > 0 {
		key := fmt.Sprintf("%v:%v", slugPrefix, req.Slug)
		log.Infof("Reading post by slug: %v", req.Slug)
		records, err = t.Store.Read(key, store.ReadPrefix())
	} else {
		key := fmt.Sprintf("%v:", timeStampPrefix)
		var limit uint
		limit = 20
		if req.Limit > 0 {
			limit = uint(req.Limit)
		}
		log.Infof("Listing posts, offset: %v, limit: %v", req.Offset, limit)
		records, err = t.Store.Read(key, store.ReadPrefix(),
			store.ReadOffset(uint(req.Offset)),
			store.ReadLimit(limit))
	}

	if err != nil {
		return err
	}
	rsp.Posts = make([]*post.Post, len(records))
	for i, record := range records {
		postRecord := &Post{}
		err := json.Unmarshal(record.Value, postRecord)
		if err != nil {
			return err
		}
		rsp.Posts[i] = &post.Post{
			Id:       postRecord.ID,
			Title:    postRecord.Title,
			Slug:     postRecord.Slug,
			Content:  postRecord.Content,
			TagNames: postRecord.TagNames,
		}
	}
	return nil
}
```

After doing a `micro update .` in the project root, we can now query the posts:

```
$ micro call go.micro.service.posts Posts.Query '{"limit": 10}'
{
	"posts": [
		{
			"id": "1",
			"title": "How to Micro",
			"slug": "how-to-micro",
			"content": "Simply put, Micro is awesome."
		}
	]
}
```

Stellar! Now only `Delete` remains to be implemented to have a basic post service.

## Deleting posts

Since we have already defined `Delete` in our proto, we only have to implement the handler:

```go
func (t *Posts) Delete(ctx context.Context, req *posts.DeleteRequest, rsp *posts.DeleteResponse) error {
	log.Info("Received Post.Delete request")
	records, err := t.Store.Read(fmt.Sprintf("%v:%v", idPrefix, req.Id))
	if err != nil && err != store.ErrNotFound {
		return err
	}
	if len(records) == 0 {
		return fmt.Errorf("Post with ID %v not found", req.Id)
	}
	post := &Post{}
	err = json.Unmarshal(records[0].Value, post)
	if err != nil {
		return err
	}

	// Delete by ID
	err = t.Store.Delete(fmt.Sprintf("%v:%v", idPrefix, post.ID))
	if err != nil {
		return err
	}
	// Delete by slug
	err = t.Store.Delete(fmt.Sprintf("%v:%v", slugPrefix, post.Slug))
	if err != nil {
		return err
	}
	// Delete by timeStamp
	return t.Store.Delete(fmt.Sprintf("%v:%v", timeStampPrefix, post.CreateTimestamp))
}
```

As it can be seen above, we had to keep in mind all the keys we inserted for a given post.
We read the post by ID first to get the slug and the timetamps, ie. to know what to delete.

## Conclusions

This brings us to the end of the initial posts tutorial series.
There are many more features we will add later, like saving and querying by tags, but this post alreadt taught us enough to digest.
We will cover those aspect in later parts of this series.

For the latest version of the code, we can consult the [github folder of the Posts service](https://github.com/micro/examples/tree/master/blog/posts).
It might contain some (or even many) additional things not covered in the post, as it is the latest version.

Recreating the version outlined in this post is left as an exercises for the reader.
Our general approach with these tutorials is to keep the snippets in the earlier posts as similar as possible to the latest version (handler names, import names, field names etc.), but reconciling the two might still prove a good exercise as the earliest versions of the services deviate from the latest one on GitHub.
