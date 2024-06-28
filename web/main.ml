let () =
  print_endline "Routes to be registered:";
  List.iter (fun (endpoint, (dir, file)) ->
    Printf.printf "Endpoint %s - File %s in directory %s\n" endpoint file dir
  ) Routing.Routes.blog_pairs;
  print_endline "---------";
  Dream.run
  @@ Dream.logger
  @@ Dream.router Routing.Routes.routes
