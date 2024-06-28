let without_extension filename = String.sub filename 0 (String.rindex filename '.')

let gen_rule directory filename =
  let template = {template|
    (subdir %DIR%
      (rule
        (target %FILE%.html)
        (mode promote)
        (deps %FILE%.exe)
        (action
          (with-stdout-to %{target} (run ./%FILE%.exe)))))

    (subdir %DIR%
      (rule
        (target %FILE%.exe)
        (deps %FILE%.ml)
        (action
          (run ocamlfind ocamlc -o %{target} -linkpkg -package tyxml %{deps}))))
  |template} in
  let filename_no_ext = without_extension filename in
  Str.global_replace (Str.regexp "\\%DIR\\%") directory template |>
  Str.global_replace (Str.regexp "\\%FILE\\%") filename_no_ext


let () =
  let dirs =
    Sys.readdir "." |>
    Array.to_seq |>
    Seq.filter Sys.is_directory |>
    Array.of_seq
  in
  Array.iter (fun dir ->
    let files = Sys.readdir dir in
    Array.iter (fun f -> print_endline @@ gen_rule dir f) files
  ) dirs
