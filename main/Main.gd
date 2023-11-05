extends Node2D

signal levelUp

const BASIC_LEVEL = 5
const BONUS_TIME = 5
export (PackedScene) var Gem
var Cherry = preload("res://gem/Cherry.tscn")
var Froggy = preload("res://enemy/Froggy.tscn")

var screansize = Vector2.ZERO
var level = 0
var score = 0
var time_left = 0
onready var GameOverTimer = Timer.new()

func _ready():
	$Froggy.visible = false
	randomize()
	timer_settings()
	$HUD/GameOverLabel.visible = false
	time_left = 30
	$HUD.update_timer(time_left)
	screansize = get_viewport().get_visible_rect().size
	spawn_gems()
	set_cherry_timer()
	$Froggy.visible = true	


func timer_settings():
	GameOverTimer.wait_time = 2
	GameOverTimer.connect("timeout",self, "_onGameOverTimer_timeout")
	add_child(GameOverTimer)
	
func _onGameOverTimer_timeout():
	get_tree().change_scene("res://menu/Menu.tscn")

func _process(delta):
	update_plataform_position()
	if $GemContainer.get_child_count() == 0:
#		$Froggy.free()
		level += 1
		emit_signal("levelUp")
		$LevelUpAudio.play()
		time_left += BONUS_TIME
		spawn_gems()
#		var froggy = Froggy.instance()
#		froggy.position.x = rand_range(25,460)
#		froggy.position.y = rand_range(25,700)
		
#		add_child(froggy)

func update_plataform_position():
	$Platform.position.x = $Froggy.position.x

func spawn_gems():
	for index in range (BASIC_LEVEL + level):
		var Gema = Gem.instance()
		Gema.position = Vector2(rand_range(0,screansize.x), rand_range(0,screansize.y))
		$GemContainer.add_child(Gema)


func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	
	if time_left <= 0:
		game_over()

func _on_Player_picked(type):#type va a recibir gen | cherry
	match type:
		"gem":
			score += 1
			$HUD.update_score(score)
		"cherry":
			time_left += 5
			$HUD.update_timer(time_left)


func _on_Main_levelUp():
	$HUD.update_level(level)

func game_over():
	$GameTimer.stop()
	$HUD/GameOverLabel.visible = true
	$Player.game_over()
	GameOverTimer.start()

func set_cherry_timer():
	var interval = rand_range(5,10)
	$CherryTimer.wait_time = interval
	$CherryTimer.start()


func _on_CherryTimer_timeout():
	$CherryTimer.stop()
	var cherry = Cherry.instance()
	cherry.position.x = rand_range(25,460)
	cherry.position.y = rand_range(25,700)
	$GemContainer.add_child(cherry)
	set_cherry_timer()


func _on_Player_hurt():
	game_over()

