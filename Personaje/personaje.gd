extends CharacterBody2D

const VELOCIDAD_BASE = 50
const FUERZA_DE_SALTO = -450
const GRAVEDAD = 1000
const ACELERACION_BASE = 100
var saltos_realizados = 0
var aceleracion_actual = 100
var velocidad_actual = 0
var posicion_actual = Vector2(0,0) #solo lo utilice para chequear numeros de otras variables


func incremento_de_aceleracion_actual(direccionX, delta): 
	#Con esta funcion incremento el valor de aceleracion en relacion al valor de Delta
	if direccionX != 0:
		aceleracion_actual += ACELERACION_BASE * delta;
	else:
		aceleracion_actual = 0;

#En esta funcion estaba trabajando con el rebote pero me di cuenta tarde que 
#move_and_collide tiene conflcitos con move_and_slide.
#func rebotar(delta): 
	#var info_de_colision = move_and_collide(posicion_actual * delta)
	#if info_de_colision:
		#posicion_actual = info_de_colision.get_normal() * VELOCIDAD_BASE



func _physics_process(delta):
	if !is_on_floor():
		velocity.y += GRAVEDAD * delta;
	
	#Para saltar utilizo la funcion is_action_pressed
	#lo cual me permite no solo saltar una vez, si no que 
	#salta multiples veces si se se mantiene la tecla presionada.
	if is_on_floor() and Input.is_action_pressed("ui_accept"):
		velocity.y = FUERZA_DE_SALTO;
		saltos_realizados = 1;
	
	#En este caso utilizo  is_action_just_pressed para hacer un segundo salto
	#en el aire, y lo limito con un contador para que no se repita infinitamente.
	if !is_on_floor() and Input.is_action_just_pressed("ui_accept") and saltos_realizados < 2:
			velocity.y = FUERZA_DE_SALTO;
			saltos_realizados += 1;
	
	
	#Para el movimiento y transiciones utilizo get_axis, cuando no se esta precionando
	#ninguna tecla el objeto baja su velocidad lentamente hasta 0 en su ultima direccion.
	#Al momento de cambiar de direccicones, de izquierda a derecha y viceversa, el objeto se
	#toma unos segundos antes de efectuar el cambio direccional, dando un efecto de pesadez.
	var direccionX = Input.get_axis("ui_left", "ui_right");
	incremento_de_aceleracion_actual(direccionX, delta);
	if direccionX:
		velocidad_actual = VELOCIDAD_BASE + aceleracion_actual;
		var cambio_de_direccion = direccionX * velocidad_actual;
		velocity.x = move_toward(velocity.x, cambio_de_direccion, VELOCIDAD_BASE/ 15);
		posicion_actual = Vector2(velocity.x, 0);
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD_BASE/ 25); 
		velocidad_actual = 0;
	
	#monitorear();
	move_and_slide();
	#rebotar(delta);

func monitorear(): #Con esto monitoreo algunos valores como la aceleracion_actual y la velocidad actual.
	$panel.text = "posicion: " + str(posicion_actual) + "\n" + "aceleracion_actual: " + str(aceleracion_actual) + "\n" + "velocidad actual: " + str(velocidad_actual) + "\n" + "saltos: " + str(saltos_realizados)

