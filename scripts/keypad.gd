extends VBoxContainer

const keys = [
	"1",    "2", "3",
	"4",    "5", "6",
	"7",    "8", "9",
	"back", "0", "enter"
]

func delete(text: String) -> String:
	if len(text) == 0:
		return ""
	return text.left(text.length() - 1)

func press(id: int) -> void:
	var focus := get_viewport().gui_get_focus_owner()
	if not focus is LineEdit:
		return
	var edit: LineEdit = focus
	if not edit.is_editing():
		return
	var key = keys[id]
	if key == "back":
		edit.delete_char_at_caret()
		return
	if key == "enter":
		edit.unedit()
		edit.text_submitted.emit(edit.text)
		return
	edit.insert_text_at_caret(key)
