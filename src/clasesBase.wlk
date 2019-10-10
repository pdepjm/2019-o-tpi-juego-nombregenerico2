import wollok.game.*
import actores.*

class DireccionHorizontal {

	const property limiteOffsetX = 5

	method posicionXInicial()

	method proximaPosicionDirecta(posicionActual)

	method posicionEstaFuera(posicion) {
		const minimoX = -limiteOffsetX
		const maximoX = game.width() + limiteOffsetX
		return !posicion.x().between(minimoX,maximoX)
	}

	method proximaPosicion(posicionActual) {
		const proximaPosicionDirecta = self.proximaPosicionDirecta(posicionActual)
		if (self.posicionEstaFuera(proximaPosicionDirecta)) {
			return game.at(self.posicionXInicial(), posicionActual.y())
		} else {
			return proximaPosicionDirecta
		}
	}

}

object izquierda inherits DireccionHorizontal {

	override method posicionXInicial() = game.width()

	override method proximaPosicionDirecta(posicionActual) = posicionActual.left(1)

}

object derecha inherits DireccionHorizontal {

	override method posicionXInicial() = 0

	override method proximaPosicionDirecta(posicionActual) = posicionActual.right(1)

}

class Movible {

	var property image
	var property position
	const property limiteOffsetX = 5 // Cuantas celdas se mueve despues de dejar la pantalla
	const velocidad // Tiempo en milisegundos que tarda en moverse de una celda a otra
	const direccion

	method moverse() {
		position = direccion.proximaPosicion(position)
	}

	method empezarMovimiento() {
		game.onTick(velocidad, "moverse movible a derecha", { self.moverse()})
	}

	method colisionarConRana() {
	}

}

class Montable inherits Movible { // Nombre horrible, hay que pensar otro

	override method moverse() {
		if (self.estaColisionandoConRana()) {
			super()
			if (!rana.posicionEstaAfuera(position)) {
				rana.position(position)
			}
		} else {
			super()
		}
	}

	method estaColisionandoConRana() {
		return game.colliders(self).contains(rana)
	}

}

class Obstaculo inherits Movible {

	override method colisionarConRana() {
		rana.morir()
	}

}

