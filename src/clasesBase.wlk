import wollok.game.*
import actores.*

class Direccion {

	const property nombre

	method proximaPosicionDirecta(posicionActual)

}

class DireccionHorizontal inherits Direccion { //Juro que todo lo que hay aca tiene una justificacion

	const property limiteOffsetX = 5
	const property opuesto
	const posicionXInicial

	method posicionEstaFuera(posicion) {
		const minimoX = -limiteOffsetX
		const maximoX = game.width() + limiteOffsetX
		return !posicion.x().between(minimoX, maximoX)
	}

	method proximaPosicionValida(posicionActual) {
		const proximaPosicionDirecta = self.proximaPosicionDirecta(posicionActual)
		if (self.posicionEstaFuera(proximaPosicionDirecta)) {
			return game.at(posicionXInicial, posicionActual.y())
		} else {
			return proximaPosicionDirecta
		}
	}

	method posicionADistanciaDirecta(posicionActual, distancia)

	override method proximaPosicionDirecta(posicionActual) = self.posicionADistanciaDirecta(posicionActual, 1)

}

object izquierda inherits DireccionHorizontal (posicionXInicial = game.width(), nombre = "left", opuesto = derecha) {

	override method posicionADistanciaDirecta(posicionActual, distancia) = posicionActual.left(distancia)

}

object derecha inherits DireccionHorizontal (posicionXInicial = 0, nombre = "right", opuesto = izquierda) {

	override method posicionADistanciaDirecta(posicionActual, distancia) = posicionActual.right(distancia)

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

	method empujarse(_) {
	}

}

class Montable inherits Movible {

	var ultimoRanaColisionada = null

	override method moverse() {
		if (self.estaColisionandoConElUltimoColisionado()) {
			ultimoRanaColisionada.cambiarPosicionForzado(direccion.proximaPosicionValida(position))
		}
		super()
	}

	method estaColisionandoConElUltimoColisionado() {
		return game.colliders(self).contains(ultimoRanaColisionada)
	}

	override method colisionarConUnaRana(unaRana) {
			ultimoRanaColisionada = unaRana
	}

}

class Obstaculo inherits Movible {

	override method colisionarConUnaRana(unaRana) {
		unaRana.morir()
	}

}

