def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end

def pbpaste
  `pbpaste`
end

def to_pg_var(id)
  pbcopy "SELECT set_config('pg.var', '#{id}', FALSE);"
end
