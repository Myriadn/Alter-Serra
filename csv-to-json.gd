extends Node

@export var dialogue_file : Array[String]
var folder_output = "res://dialogue-data/data-ready/"

func _ready() -> void:
	if dialogue_file.is_empty() : return
	for i in dialogue_file:
		var file_name = i.trim_prefix("res://dialogue-data/mentah/").trim_suffix(".csv")
		convert_csv_to_json(i, folder_output + file_name + ".json")

func convert_csv_to_json(csv_path: String, json_path: String) -> void:
	var file = FileAccess.open(csv_path, FileAccess.READ)
	if file == null:
		push_error("CSV file not found!")
		return

	var lines = file.get_as_text().split("\n")
	file.close()

	var headers = lines[0].strip_edges().split(",")
	var dialog_data := {}

	for i in range(1, lines.size()):
		if lines[i].strip_edges() == "":
			continue

		var values = lines[i].split(",")
		var row := {}

		for j in range(headers.size()):
			if j < values.size():
				var v = values[j].strip_edges()
				if v != "":
					row[headers[j]] = v

		if not row.has("id"):
			continue

		var id = row["id"]

		var node := {
			"speaker": row.get("speaker", ""),
			"text": row.get("text", ""),
			"choices": []
		}
		
		if row.has("image") :
			node["image"] = row["image"]
			
		# auto-next
		if row.has("next"):
			node["next"] = row["next"]

		# choices (support banyak)
		for c in range(1, 10): # bisa 9 pilihan
			var ck = "choice_%d" % c
			var nk = "next_%d" % c
			if row.has(ck) and row.has(nk):
				node["choices"].append({
					"text": row[ck],
					"next": row[nk]
				})

		dialog_data[id] = node

	# SAVE KE JSON
	var json_text = JSON.stringify(dialog_data, "\t")
	var out = FileAccess.open(json_path, FileAccess.WRITE)
	out.store_string(json_text)
	out.close()

	print("Dialog JSON berhasil dibuat di:", json_path)
