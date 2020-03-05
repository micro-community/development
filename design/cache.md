# Cache
Caching for `store.Store`

```go
type Cache interface {
  store.Store 
  Get
  Set
  Del
  Keys
}
```
