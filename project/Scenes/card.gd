extends PanelContainer


@onready var color_value: ColorRect = $Element/ColorValue
@onready var button: Button = $Button

@export var color: Color = "blue"

@onready var element: Panel = $Element
@onready var panel: Panel = $Panel

signal card_sent(card: PanelContainer)

func _ready() -> void:
	color_value.color = color

func hide_card():
	button.hide()
	element.hide()

func _on_button_pressed() -> void:
	print("toy presionando")
	panel.hide()
	card_sent.emit(self)
