import clasesBase.*
import wollok.game.*

class Rana {

	const property posicionInicial = game.at(2, 1)
	var property position = game.at(2, 1)
	var property vidas = 3
	var direccion = arriba
	const nombreSprite
	var property otraRana // TODO: Otra alternativa?

	method image() = nombreSprite + "/" + direccion.nombre() + ".png"

	method laOtraRanaEstaEnPosicion(posicion) = game.getObjectsIn(posicion).contains(otraRana)

	method tratarDeMoverseEnDireccion(direccionAMoverse) {
		const posicionADondeMoverse = direccionAMoverse.proximaPosicionDirecta(position)
		direccion = direccionAMoverse
		if (self.laOtraRanaEstaEnPosicion(posicionADondeMoverse)) {
			otraRana.tratarDeMoverseEnDireccion(direccionAMoverse)
		}
		if (!self.posicionEstaAfuera(posicionADondeMoverse) and !self.laOtraRanaEstaEnPosicion(posicionADondeMoverse)) {
			position = posicionADondeMoverse
		}
	}

	method posicionEstaAfuera(posicion) {
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
			direccion = arriba
			position = posicionInicial
		} else {
			game.stop()
		}
	}

	/*TODO: Tiene que haber una contador visual de vidas, entonces tiene que haber un objeto que minimamente
	 * represente visualmente las vidas. Pero si vamos a hacer un objeto de vidas, no tendriamos
	 * que hacer ese objeto maneje las vidas en vez de la rana? Para pensar.
	 */
	method colisionarConUnaRana(unaRana) {
		// TODO: eh
		game.sound("croak.mp3")
	}

}

class Tronco inherits Montable {

	const proximoTronco

	override method moverse() {
		super()
		proximoTronco.moverse()
	}

}

object troncoNulo {

	method moverse() {
	}

}

