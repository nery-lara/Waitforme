module ApplicationHelper

  def fetch_session(key)
    session_json = cache_get(key)
    session_parsed = JSON.parse(session_json)
    session = Session.new
    session.user.number = session_parsed['user']['number']
    session.user.sid = session_parsed['user']['sid']
    session.business.number = session_parsed['business']['number']
    session.business.sid = session_parsed['business']['sid']
    session
  end

  def store_session(key, session)
    cache_set(key, session.to_json)
  end
end
