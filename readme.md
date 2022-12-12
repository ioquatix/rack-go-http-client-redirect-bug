# Rack / Go HTTP Client Redirect Bug

## Ruby Example

Start the server in one terminal:

```bash
$ bundle install
$ bake server
```

In another terminal, run the client:

```bash
$ bake client
```

You should see the following output:

```
--- Posting to: http://localhost:9292/content
200
#<Protocol::HTTP::Headers [["content-type", "text/plain"], ["vary", "accept-encoding"]]>
{"hello"=>"world"}
--- Posting to: http://localhost:9292/redirect-301
200
#<Protocol::HTTP::Headers [["content-type", "text/plain"], ["vary", "accept-encoding"]]>
{}
--- Posting to: http://localhost:9292/redirect-302
200
#<Protocol::HTTP::Headers [["content-type", "text/plain"], ["vary", "accept-encoding"]]>
{}
--- Posting to: http://localhost:9292/redirect-307
200
#<Protocol::HTTP::Headers [["content-type", "text/plain"], ["vary", "accept-encoding"]]>
{"hello"=>"world"}
```

This shows the correct behaviour of the redirets.

## Go Example

With the same server running, run the Go client:

```bash
$ go run client.go
```

You will see 500 errors as the requests are malformed.
