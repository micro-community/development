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
* local															127.0.0.1:8081
  platform                          proxy.m3o.com
```

has the local environment picked. If not, we can issue `micro env set local` to remedy.   

Now back to the `micro new` command:

```
$ micro new posts
$ ls posts
Dockerfile	Makefile	README.md	generate.go	go.mod		handler		main.go		proto
```

Great! The best way to start a service is to define the proto. The generated default should be something similar to this:

```sh
$ cd posts; # step into project root
$ cat proto/posts.proto 
syntax = "proto3";

package posts;

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
- `Save` for blog insert and update
- `Query` for reading and listing
- `Delete` for deletion

Let's start with the post method. Modify our `proto/posts.proto` file to match the following:

<a name="posts-proto"></a>
```proto
syntax = "proto3";

package post;
option go_package = "proto;posts";

service Posts {
	rpc Save(SaveRequest) returns (SaveResponse) {}
}

message Post {
	string id = 1;
	string title = 2;
	string slug = 3;
	string content = 4;
	int64 timestamp = 5;
	repeated string tagNames = 6;
}
message SaveRequest {
	Post post = 1;
}

message SaveResponse {
	Post post = 1;
}
```

To regenerate the proto, we have to issue the `make proto` command in the project root.
Let's adjust the handler to match our proto!

```go
package handler

import (
	"context"

	"github.com/micro/go-micro/v3/client"
	"github.com/micro/micro/v3/service/logger"

	pb "posts/proto"
)

type Posts struct {
	Client client.Client
}

func (p *Posts) Save(ctx context.Context, req *pb.SaveRequest, rsp *pb.SaveResponse) error {
	logger.Info("Received Posts.Save request")
	return nil
}
```

Now, the `main.go`:

```go
package main

import (
	"posts/handler"
	pb "posts/proto"

	"github.com/micro/micro/v3/service"
	"github.com/micro/micro/v3/service/logger"
)

func main() {
	// New Service
	srv := service.New(
		service.Name("posts"),
		service.Version("latest"),
	)

	// Register Handler
	pb.RegisterPostsHandler(srv.Server(), &handler.Posts{
		Client: srv.Client(),
	})

	// Run service
	if err := srv.Run(); err != nil {
		logger.Fatal(err)
	}
}
```

At this point `micro run .` in project root should deploy our post service. Let's verify with `micro logs posts`:

```
$ micro logs posts
Starting [service] posts
Server [grpc] Listening on [::]:53031
Registry [service] Registering node: posts-b36361ae-f2ae-48b0-add5-a8d4797508be
```

(The exact output might depend on the actual config format configuraton.)

## Saving posts

Let's make our service do something useful now: save a post. We define our model, the `Post` type, to match the proto 
and then modify the handler. The handler should now look like:

```go
package handler

import (
	"context"
	pb "posts/proto"

	"github.com/micro/go-micro/v3/client"
	"github.com/micro/micro/v3/service/errors"
)

type Posts struct {
	Client client.Client
}

type Post struct {
	ID              string   `json:"id"`
	Title           string   `json:"title"`
	Slug            string   `json:"slug"`
	Content         string   `json:"content"`
	CreateTimestamp int64    `json:"create_timestamp"`
	UpdateTimestamp int64    `json:"update_timestamp"`
	TagNames        []string `json:"tagNames"`
}

func (p *Posts) Save(ctx context.Context, req *pb.SaveRequest, rsp *pb.SaveResponse) error {
	if len(req.Post.Id) == 0 || len(req.Post.Title) == 0 || len(req.Post.Content) == 0 {
		return errors.BadRequest("posts.Save", "ID, title or content is missing")
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
import (
	// other imports
	"github.com/micro/micro/v3/service/store"
	gostore "github.com/micro/go-micro/v3/store"
)

// ...

// Save a post
func (p *Posts) Save(ctx context.Context, req *pb.SaveRequest, rsp *pb.SaveResponse) error {
	if len(req.Post.Id) == 0 || len(req.Post.Title) == 0 || len(req.Post.Content) == 0 {
		return errors.BadRequest("posts.Save", "ID, title or content is missing")
	}

	post := &Post{
		ID:              req.Post.Id,
		Title:           req.Post.Title,
		Content:         req.Post.Content,
		Slug:            slug.Make(req.Post.Title),
		TagNames:        req.Post.TagNames,
		CreateTimestamp: time.Now().Unix(),
		UpdateTimestamp: time.Now().Unix(),
	}
	
	bytes, err := json.Marshal(post)
	if err != nil {
		return err
	}

	return 	store.Write(&gostore.Record{
		Key:   post.Slug,
		Value: bytes,
	})
}
```

After a `micro update .` in project root, we can start saving posts!

```
micro posts save --post_id=1 --post_title="Post one" --post_content="First saved post"
micro posts save --post_id=2 --post_title="Post two" --post_content="Second saved post"
```

WOW! We are on a roll! We've just saved two posts. There is one problem however. There is no way yet to get the posts out of the post service.
Now luckily, `micro store` commands are designed to interact with the saved data. `micro store list` will list all keys saved (but not values):

```
$ micro store list --table=posts
post-one
post-two
```

Why are these keys there? Remember we saved the posts by slug. Okay, but where are the values? `micro store read` comes to our rescue:

```
$ micro store read --table=posts post-one
{"id":"1","title":"Post one", "content":"First saved post", "create_timestamp":1591970869, "update_timestamp":1591970869}
$ micro store read --table=posts post-two
{"id":"2","title":"Post two", "content":"Second saved post",  "create_timestamp":1591970870, "update_timestamp":1591970870}
```

It's a bit annoying however to read values one by one, that' why the `--prefix` flag exists:

```
$ micro store read --table=posts --prefix post
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
micro store read --table=posts --prefix --offset 0 --limit 20 post
```

would give back the first 20 posts, 

```
micro store read --table=posts --prefix --offset 20 --limit 20 post
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
	idPrefix        = "id"
	slugPrefix      = "slug"
	timestampPrefix = "timestamp"
)

func (p *Posts) Save(ctx context.Context, req *pb.SaveRequest, rsp *pb.SaveResponse) error {
	if len(req.Post.Id) == 0 || len(req.Post.Title) == 0 || len(req.Post.Content) == 0 {
		return errors.BadRequest("posts.Save", "ID, title or content is missing")
	}

	// read by parent ID so we can check if it exists without slug changes getting in the way.
	records, err := store.Read(fmt.Sprintf("%v:%v", idPrefix, req.Post.Id))
	if err != nil && err != gostore.ErrNotFound {
		return err
	}
	postSlug := slug.Make(req.Post.Title)

	// If no existing record is found, create a new one
	if len(records) == 0 {
		return p.savePost(ctx, nil, &Post{
			ID:              req.Post.Id,
			Title:           req.Post.Title,
			Content:         req.Post.Content,
			TagNames:        req.Post.TagNames,
			Slug:            postSlug,
			CreateTimestamp: time.Now().Unix(),
		})
	}

	record := records[0]

	oldPost := &Post{}
	if err := json.Unmarshal(record.Value, oldPost); err != nil {
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
	recordsBySlug, err := store.Read(fmt.Sprintf("%v:%v", slugPrefix, postSlug))
	if err != nil && err != gostore.ErrNotFound {
		return err
	}
	otherSlugPost := &Post{}
	if err := json.Unmarshal(record.Value, otherSlugPost); err != nil {
		return err
	}
	if len(recordsBySlug) > 0 && oldPost.ID != otherSlugPost.ID {
		return errors.BadRequest("posts.Save", "An other post with this slug already exists")
	}

	return p.savePost(ctx, oldPost, post)
}

func (p *Posts) savePost(ctx context.Context, oldPost, post *Post) error {
	bytes, err := json.Marshal(post)
	if err != nil {
		return err
	}

	// Save post by ID
	record := &gostore.Record{
		Key:   fmt.Sprintf("%v:%v", idPrefix, post.ID),
		Value: bytes,
	}
	if err := store.Write(record); err != nil {
		return err
	}

	// Delete old slug index if the slug has changed
	if oldPost.Slug != post.Slug {
		if err := store.Delete(fmt.Sprintf("%v:%v", slugPrefix, post.Slug)); err != nil {
			return err
		}
	}

	// Save post by slug
	slugRecord := &gostore.Record{
		Key:   fmt.Sprintf("%v:%v", slugPrefix, post.Slug),
		Value: bytes,
	}
	if err := store.Write(slugRecord); err != nil {
		return err
	}

	// Save post by timeStamp
	return store.Write(&gostore.Record{
		// We revert the timestamp so the order is chronologically reversed
		Key:   fmt.Sprintf("%v:%v", timestampPrefix, math.MaxInt64-post.CreateTimestamp),
		Value: bytes,
	})
}
```

We can again invoke the Micro CLI to play around with our service after a `micro update .` in the project root.
Let's insert two posts through the service we wote:

```
micro posts save --post_id="1" --post_title="How to Micro" --post_content="Simply put, Micro is awesome."
micro posts save --post_id="2" --post_title="Fresh posts are fresh" --post_content="This post is fresher than the How to Micro one"
```

## Querying posts

While we can query the data through `micro store list --table=posts`, we still can't do that through the service.
Implementing the `Query` handler will enable doing that, but first we need to amend and regenerate [our proto](#posts-proto). We will also define the `Delete` endpoint in this step so we don't have to touch this file again soon:

```proto
syntax = "proto3";

package posts;
option go_package = "proto;posts";

service Posts {
	// Query currently only supports read by slug or timestamp, no listing.
	rpc Query(QueryRequest) returns (QueryResponse) {}
	rpc Save(SaveRequest) returns (SaveResponse) {}
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

message SaveRequest {
	Post post = 1;
}

message SaveResponse {
	Post post = 1;
}

message DeleteRequest {
	string id = 1;
}

message DeleteResponse {}
```

A `make proto` issued in the command root should regenerate the Go proto files and we should be ready to define our new handler:

```go
// Query the posts
func (p *Posts) Query(ctx context.Context, req *pb.QueryRequest, rsp *pb.QueryResponse) error {
	var opts []gostore.ReadOption
	var key string

	// detemine the key
	if len(req.Slug) > 0 {
		key = fmt.Sprintf("%v:%v", slugPrefix, req.Slug)
	} else {
		key = fmt.Sprintf("%v:", timestampPrefix)
		opts = append(opts, gostore.ReadPrefix())
	}

	// set the limit
	if req.Limit > 0 {
		opts = append(opts, gostore.ReadLimit(uint(req.Limit)))
	} else {
		opts = append(opts, gostore.ReadLimit(20))
	}

	// execute the query
	records, err := store.Read(key, opts...)
	if err != nil {
		return err
	}

	// serialize the response
	rsp.Posts = make([]*pb.Post, len(records))
	for i, record := range records {
		postRecord := &Post{}
		if err := json.Unmarshal(record.Value, postRecord); err != nil {
			return err
		}

		rsp.Posts[i] = &pb.Post{
			Id:       postRecord.ID,
			Title:    postRecord.Title,
			Slug:     postRecord.Slug,
			Content:  postRecord.Content,
			TagNames: postRecord.TagNames,
		}
	}
	return nil
}

// Delete a post
func (p *Posts) Delete(ctx context.Context, req *pb.DeleteRequest, rsp *pb.DeleteResponse) error {
	return nil
}
```

After doing a `micro update .` in the project root, we can now query the posts:

```
$ micro posts query --limit=10
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
// Delete a post
func (p *Posts) Delete(ctx context.Context, req *pb.DeleteRequest, rsp *pb.DeleteResponse) error {
	records, err := store.Read(fmt.Sprintf("%v:%v", idPrefix, req.Id))
	if err == gostore.ErrNotFound {
		return errors.NotFound("posts.Delete", "Post not found")
	} else if err != nil {
		return err
	}

	post := &Post{}
	if err := json.Unmarshal(records[0].Value, post); err != nil {
		return err
	}

	// Delete by ID
	if err = store.Delete(fmt.Sprintf("%v:%v", idPrefix, post.ID)); err != nil {
		return err
	}

	// Delete by slug
	if err := store.Delete(fmt.Sprintf("%v:%v", slugPrefix, post.Slug)); err != nil {
		return err
	}

	// Delete by timeStamp
	return store.Delete(fmt.Sprintf("%v:%v", timestampPrefix, post.CreateTimestamp))
}
```

As it can be seen above, we had to keep in mind all the keys we inserted for a given post.
We read the post by ID first to get the slug and the timetamps, ie. to know what to delete.

## Conclusions

This brings us to the end of the initial posts tutorial series.
There are many more features we will add later, like saving and querying by tags, but this post alreadt taught us enough to digest.
We will cover those aspect in later parts of this series.

For the latest version of the code, we can consult the [github folder of the Posts service](https://github.com/micro/services/tree/master/blog/posts).
It might contain some (or even many) additional things not covered in the post, as it is the latest version.

Recreating the version outlined in this post is left as an exercises for the reader.
Our general approach with these tutorials is to keep the snippets in the earlier posts as similar as possible to the latest version (handler names, import names, field names etc.), but reconciling the two might still prove a good exercise as the earliest versions of the services deviate from the latest one on GitHub.
