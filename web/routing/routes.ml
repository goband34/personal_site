let blog_pairs =
  let has_html_extension filename = Str.string_match (Str.regexp ".*\\.html") filename 0 in
  let without_extension filename = String.sub filename 0 (String.rindex filename '.') in
  Sys.readdir "static/posts" |>
  Array.to_seq |>
  Seq.filter has_html_extension |>
  Seq.map without_extension |>
  Seq.map (fun post ->
    ("/blog/" ^ post, ("static/posts", post ^ ".html"))
  ) |>
  List.of_seq

let routes =
  List.map (fun (endpoint, (dir, file)) -> Dream.get endpoint @@ Dream.from_filesystem dir file) blog_pairs
