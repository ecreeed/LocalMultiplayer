class_name JSON_mgr
extends Node

# JSON FILES DATA ARE KEPT AS AN ARRAY OF DICTS

# Get from the JSON
func read_json(filePath: String) -> Array:
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Array:
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("File doesn't exist! [%s]", filePath)
	return []

# Write to the JSON
func write_json(filePath: String, data: Array) -> void:
	if FileAccess.file_exists(filePath):
		if data:
			var dataFile = FileAccess.open(filePath, FileAccess.WRITE)
			var json_string = JSON.stringify(data)
			dataFile.store_line(json_string)
			dataFile.close()
		else:
			print("No data to write to file!")
	else:
		print("File doesn't exist! [%s]", filePath)
