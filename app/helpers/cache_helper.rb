module CacheHelper

  def cache_get(key)
    $redis.get(key)
  end

  def cache_set(key, value)
    $redis.set(key, value)
  end

end
