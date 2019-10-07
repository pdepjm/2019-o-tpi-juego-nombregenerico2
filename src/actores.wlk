import clasesBase.*
import wollok.game.*

object rana {

	const posicionInicial = game.at(5, 1)
	var property image = "rana/up.png"
	var property position = posicionInicial
	var vidas = 3

	//TODO: Seria mejor sacar los metodos up, down, left y right y hacer que se reciba el tratarDeMoverseAPosicion directamente por el onPressDo?
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
		if (!self.posicionEstaAfuera(posicionADondeMoverse)) {
			position = posicionADondeMoverse
			image = "rana/" + direccion + ".png"
		}
	}

	method posicionEstaAfuera(posicion) { //TODO: Este metodo le deberia pertenecer a la rana?
		const maximoX = game.width()
		const maximoY = game.height()
		const minimoX = 0
		const minimoY = 1
		const posicionX = posicion.x()
		const posicionY = posicion.y()
		return (posicionY < minimoY or posicionX < minimoX) or (posicionX >= maximoX or posicionY >= maximoY)
	}

	method morir() {
		if (vidas != 0) {
			vidas--
				// TODO: Aca hacer la animacion de la muerte
			image = "rana/up.png"
			position = posicionInicial
		} else {
			game.stop()
		}
	} /*TODO: Tiene que haber una contador visual de vidas, entonces tiene que haber un objeto que minimamente
	 * represente visualmente las vidas. Pero si vamos a hacer un objeto de vidas, no tendriamos
	 * que hacer ese objeto maneje las vidas en vez de la rana? Para pensar.
	 */

}

