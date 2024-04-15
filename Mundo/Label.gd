extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	$Comandos.text = "Saltar: Espacio" + "\n" + "Derecha: ->" + "\n" + "Izquierda: <-"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
