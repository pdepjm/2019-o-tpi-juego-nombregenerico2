import wollok.game.*
import actores.*

class Direccion {

	const property nombre

	method proximaPosicionDirecta(posicionActual)

}

class DireccionHorizontal inherits Direccion { //Juro que todo lo que hay aca tiene una justificacion

	const property limiteOffsetX = 5
	const property opuesto

	method posicionXInicial()

	method posicionEstaFuera(posicion) {
		const minimoX = -limiteOffsetX
		const maximoX = game.width() + limiteOffsetX
		return !posicion.x().between(minimoX, maximoX)
	}

	method proximaPosicionValida(posicionActual) {
		const proximaPosicionDirecta = self.proximaPosicionDirecta(posicionActual)
		if (self.posicionEstaFuera(proximaPosicionDirecta)) {
			return game.at(self.posicionXInicial(), posicionActual.y())
		} else {
			return proximaPosicionDirecta
		}
	}
	
	method posicionADistanciaDirecta(posicionActual,distancia) 
	
	override method proximaPosicionDirecta(posicionActual) = self.posicionADistanciaDirecta(posicionActual,1) 

}

object izquierda inherits DireccionHorizontal (nombre = "left",opuesto = derecha) {

	override method posicionXInicial() = game.width()

	override method posicionADistanciaDirecta(posicionActual,distancia) = posicionActual.left(distancia)

}

object derecha inherits DireccionHorizontal (nombre = "right", opuesto = izquierda) {

	override method posicionXInicial() = 0

	override method posicionADistanciaDirecta(posicionActual,distancia) = posicionActual.right(distancia)

}

object arriba inherits Direccion (nombre = "up") {

	override method proximaPosicionDirecta(posicionActual) = posicionActual.up(1)

}

object abajo inherits Direccion (nombre = "down") {

	override method proximaPosicionDirecta(posicionActual) = posicionActual.down(1)

}

class Movible {

	var property image
	var property position
	const property limiteOffsetX = 5 // Cuantas celdas se mueve despues de dejar la pantalla
	const velocidad // Tiempo en milisegundos que tarda en moverse de una celda a otra
	const direccion

	method moverse() {
		position = direccion.proximaPosicionValida(position)
	}

	method empezarMovimientoConstante() {
		game.onTick(velocidad, "moverse movible a derecha", { self.moverse()})
	}

	method colisionarConUnaRana(unaRana) {
	}

}

class Montable inherits Movible {

	var ultimoColisionado = null

	override method moverse() {
		if (self.estaColisionandoConElUltimoColisionado()) {
			super()
			if (!ultimoColisionado.posicionEstaAfuera(position)) {
				ultimoColisionado.position(position)
			}
		} else {
			super()
		}
	}

	method estaColisionandoConElUltimoColisionado() {
		return game.colliders(self).contains(ultimoColisionado)
	}

	override method colisionarConUnaRana(unaRana) {
		ultimoColisionado = unaRana
	}

}

class Obstaculo inherits Movible {

	override method colisionarConUnaRana(unaRana) {
		unaRana.morir()
	}

}

