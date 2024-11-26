extends Control

@onready var card: PanelContainer = $VBoxContainer/Background/VBoxContainer/Row1/Card
@onready var card_2: PanelContainer = $VBoxContainer/Background/VBoxContainer/Row1/Card2
@onready var card_3: PanelContainer = $VBoxContainer/Background/VBoxContainer/Row1/Card3
@onready var card_4: PanelContainer = $VBoxContainer/Background/VBoxContainer/Row2/Card4
@onready var card_5: PanelContainer = $VBoxContainer/Background/VBoxContainer/Row2/Card5
@onready var card_6: PanelContainer = $VBoxContainer/Background/VBoxContainer/Row2/Card6

@onready var move_count: Label = $VBoxContainer/MatchInfo/MoveCount
@onready var time_label: Label = $VBoxContainer/MatchInfo/Time

@onready var row_1: HBoxContainer = $VBoxContainer/Background/VBoxContainer/Row1
@onready var row_2: HBoxContainer = $VBoxContainer/Background/VBoxContainer/Row2

# cards_collected: Used to trigger the win condition when all cards are collected
# moves: Counter for every time you open a card
# open_cards: 
var cards_collected: int = 0
var moves: int = 0


#@onready var card = preload("res://Scenes/card.tscn")
var colors = ["yellow", "blue", "red", "green", "pink", "purple", "orange", "white"]
var chosen_colors = []

var selected_cards = []

var time: float = 0.0
var is_playing: bool = false

var moves_score
var time_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cards = [card,card_2,card_3,card_4,card_5,card_6]
	cards.shuffle()
	print("Estoy en la nueva escena")
	assign_colors(cards)
	#fill_rows()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_count.text = "Moves: " + str(moves)
	if is_playing == true:
		time += delta
	
	var time_value: float = time
	var sec: String
	var mins: String
	
	var miliseconds = fmod(time_value, 1) * 100
	var seconds = fmod(time_value, 60)
	var minutes = fmod(time_value, 3600) / 60
	sec = "%02d" % seconds
	mins = "%02d:" % minutes
	time_label.text = "Time: " + mins + sec
	

# Chooses 3 random colors from the "colors" array and assigns them to the cards
func assign_colors(cards: Array):
	colors.shuffle()
	#print("Color at pos 0 is: " + colors[0])
	#print("Color at pos 1 is: " + colors[1])
	#print("Color at pos 2 is: " + colors[2])
	chosen_colors.append(colors[0])
	#print("Color added at pos 0 is: " + chosen_colors[0])
	chosen_colors.append(colors[1])
	#print("Color added at pos 1 is: " + chosen_colors[1])
	chosen_colors.append(colors[2])
	#print("Color added at pos 2 is: " + chosen_colors[2])
	cards[0].color_value.color = chosen_colors[0]
	cards[1].color_value.color = chosen_colors[1]
	cards[2].color_value.color = chosen_colors[2]
	cards[3].color_value.color = chosen_colors[0]
	cards[4].color_value.color = chosen_colors[1]
	cards[5].color_value.color = chosen_colors[2]

# Create cards, assign its colors and adds it to the rows.
func fill_rows():
	# Array for created cards
	var cards = []
	
	# Creating the cards assigning the color and adding to the cards array
	#var card1 = card.instantiate()
	#card1.color = chosen_colors[0]
	#cards.append(card1)
	#var card2 = card.instantiate()
	#card2.color = chosen_colors[1]
	#cards.append(card2)
	#var card3 = card.instantiate()
	#card3.color = chosen_colors[2]
	#cards.append(card3)
	#var card4 = card.instantiate()
	#card4.color = chosen_colors[0]
	#cards.append(card4)
	#var card5 = card.instantiate()
	#card5.color = chosen_colors[1]
	#cards.append(card5)
	#var card6 = card.instantiate()
	#card6.color = chosen_colors[2]
	#cards.append(card6)
	#
	## Shuffles the array to give the cards random positions in the row
	#cards.shuffle()
	#
	## Adding the cards to the rows
	#row_1.add_child(cards.pop_back())
	#row_1.add_child(cards.pop_back())
	#row_1.add_child(cards.pop_back())
	#row_2.add_child(cards.pop_back())
	#row_2.add_child(cards.pop_back())
	#row_2.add_child(cards.pop_back())


func _on_card_card_sent(card: PanelContainer) -> void:
	## Sets the player playing status to true to start counting time
	if is_playing == false:
		is_playing = true
	
	if selected_cards.size() == 0:
		moves += 1
		selected_cards.append(card)
		return
	
	if selected_cards.size() == 1 and card != selected_cards.front():
		moves += 1
		selected_cards.append(card)
		compare_selected_cards()
		return
	elif selected_cards.size() == 1 and card == selected_cards.front():
		return
	elif selected_cards.size() == 2 and card == selected_cards[0]:
		return
	elif selected_cards.size() == 2 and card == selected_cards[1]:
		return
	else:
		moves += 1
		close_cards()
		selected_cards.clear()
		selected_cards.append(card)
		return


func compare_selected_cards():
	if selected_cards[0].color_value.color == selected_cards[1].color_value.color:
		cards_collected += 2
		hide_cards()
		if cards_collected == 6:
			is_playing = false
			print("GAME OVER")
			#get_tree().paused = true
	else:
		return

## Hide cards that the player have guessed
func hide_cards():
	selected_cards[0].hide_card()
	selected_cards[1].hide_card()
	selected_cards.clear()

## Cover cards that the player did no guess
func close_cards():
	selected_cards[0].panel.show()
	selected_cards[1].panel.show()


func _on_restart_button_pressed() -> void:
	#get_tree().paused = false
	get_tree().reload_current_scene()
