# Add more querying capabilities to the store

As we have seen KV stores by themselves can be a bit hard to manage. Often we need to manually maintain indexes (for queries like: list customers by type, list customers who spent more then X etc).
For this reason at Hailo we wrote [gocassa](https://github.com/gocassa/gocassa), which proved to be a good spot between efficiency and convenience.


There are a couple of way to go about this but I'm proposing the following:


- Add suppport to passing in multiple IDs to the read function, the following would be a low impact change. The reason for this is twofold: 1, it is a very basic use case in itself 2. it doesn't force our hand to denormalize and duplicate the full entry for each index when maintaining the indexes. Regardless if a given gocassa like library decides to denormalize or not, they should be added.

```go
func IDs(ids []string) Option {
	return func(r *Options) {
		r.Ids = p
	}
}

store.Read("", store.IDs("a", "b"))
// or equivalent to
store.Read("a", store.IDs("b"))
```

At this point I think we are stretching the limits of the store interface and a more flexible `Query` type should be passed in to read:

```sh
// func ID(string) Query
// func IDs([]string) Query
// func Prefix(string) Query
store.Read(IDs("a", "b"))
```

but one week before release is not the time to rewrite the whole interface so this was just mentioned as a curiosity.

- Create an experimental package to implement the gocassa-like library on top of the store

Title says it all really. We can even include info about this package in the reference. I propose `micro/experimental`.


## Concerns about existing implementation/interface

I will use this document to outline some thoughs I've had while pondering the store:

## The problem of offsets

Most key value stores like Cassandra doesn't support offsets, and pagination happens with a `from/start` string ie. the database finds that string in the ordered key set and returns the first X number (ie the `limit` parameter) of them.

Us supporting the `offset` parameter reduces the portability of our store (finder to implement it on a "pure" KV store like Cassandra).
However it's way way better from a UX standpoint to have `offset` than `start`. Still thought about mentioning this.

## List call

`List` should probably called `ListKeys`, or merged with `Read` (which might be called `Read`, `Query` or `List`).
Read and List is confusing when they refer to different things (Read records, List keys).

If one wants only keys, it could be an option to the `Read` endpoint to not return the values.