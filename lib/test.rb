def tim(n,interval)
  t = n.send(interval).from_now.strftime("%s").to_i
  t
end

def cycle(n,interval)
  t = JsonWebToken.encode(:id => 5, :exp => tim(n,interval))
  out = JsonWebToken.decode(t)
  out = DateTime.strptime(out["exp"].to_s,'%s')
end
