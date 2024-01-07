extends CanvasLayer

signal act_1
signal act_2
signal act_3
signal act_4
signal act_5
signal act_6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_act_1():
	act_1.emit()

func _on_act_2():
	act_2.emit()

func _on_act_3():
	act_3.emit()

func _on_act_4():
	act_4.emit()

func _on_act_5():
	act_5.emit()

func _on_act_6():
	act_6.emit()
