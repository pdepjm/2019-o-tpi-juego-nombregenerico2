import clasesBase.*
import wollok.game.*

object rana {

	var property image = "rana/up.png"
	var property position = game.at(5, 0)
	var estaMoviendose = false

	// Seria mejor sacar los metodos up, down, left y right y hacer que se reciba el tratarDeMoverseAPosicion directamente por el onPressDo?
	method up() {
		self.tratarDeMoverseAPosicion(position.up(1), "up")
	}

	method down() {
		self.tratarDeMoverseAPosicion(position.down(1), "down")
	}

	method left() {
		self.tratarDeMoverseAPosicion(position.left(1), "left")
	}

	method right() {
		self.tratarDeMoverseAPosicion(position.right(1), "right")
	}

	method tratarDeMoverseAPosicion(posicionADondeMoverse, direccion) {
		if (!self.posicionEstaAfuera(posicionADondeMoverse) and !estaMoviendose) {
			estaMoviendose = true
			game.schedule(0, { position = posicionADondeMoverse // El schedule es para hacer que el movimiento no sea tan rapido
				estaMoviendose = false
				image = "rana/" + direccion + ".png"
			})
		}
	}

	method posicionEstaAfuera(posicion) { // Este metodo le deberia pertenecer a la rana?
		const maximoX = game.width()
		const maximoY = game.height()
		const posicionX = posicion.x()
		const posicionY = posicion.y()
		return (posicionY < 0 or posicionX < 0) or (posicionX >= maximoX or posicionY >= maximoY)
	}

}

