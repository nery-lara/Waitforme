module CacheHelper

  def cache_get(key)
    $redis.get(key)
  end

  def cache_set(key, value)
    $redis.set(key, value)
  end

  def cache_incr(key)
    $redis.incr(key)
  end

  def cache_set_add(key, value)
    $redis.sadd(key, value)
  end
end
