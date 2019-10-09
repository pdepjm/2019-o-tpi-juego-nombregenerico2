import wollok.game.*
import actores.*

class Movible {

	var property image
	var property position
	const velocidad // Tiempo en milisegundos que tarda en moverse de una celda a otra
	const limiteOffsetX = 5 // Cuantas celdas se mueve despues de dejar la pantalla

	method moverseALaDerecha() {
		if (position == game.at(game.width() + limiteOffsetX, position.y())) {
			position = game.at(0, position.y())
		} else position = position.right(1)
	}

	method moverseALaIzquierda() {
		if (position == game.at(-limiteOffsetX, position.y())) {
			position = game.at(game.width(), position.y())
		} else position = position.left(1)
	}

	method empezarMovimientoDerecha() {
		game.onTick(velocidad, "moverse movible a derecha", { self.moverseALaDerecha()})
	}

	method empezarMovimientoIzquierda() {
		game.onTick(velocidad, "moverse movible a izquierda", { self.moverseALaIzquierda()})
	}

	method colisionarConRana() {
	}

}

class Montable inherits Movible { // Nombre horrible, hay que pensar otro

	override method moverseALaDerecha() {
		if (self.estaColisionandoConRana()) {
			super()
			if (!rana.posicionEstaAfuera(position)) {
				rana.position(position)
			}
		} else {
			super()
		}
	}

	override method moverseALaIzquierda() {
		if (self.estaColisionandoConRana()) {
			super()
			if (!rana.posicionEstaAfuera(position)) {
				rana.position(position)
			}
		} else{
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

