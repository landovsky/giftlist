def tim(n,interval)
  t = n.send(interval).from_now.strftime("%s").to_i
  t
end

def cycle(n,interval)
  u = User.load_random
  t = u.token_for_list(list_id: 5, interval: interval, n: n)
  #t = JsonWebToken.encode(:id => 5, :exp => tim(n,interval))
  decode_helper(t)
end

def decode_helper(token)
  d = JsonWebToken.decode(token)
  d.each do |k,v|
    d[k] = DateTime.strptime(v.to_s,'%s') if k == "exp"
  end
  d
end