output "rendered" {value="${element(concat(data.template_file.user_data.*.rendered, list("")), 0)}"}
