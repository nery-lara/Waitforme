$redis = Redis::Namespace.new("waitforme",
  :redis =>Redis.new(host: "waitforme-redis-001.dop21n.0001.use2.cache.amazonaws.com", port: 6379))
