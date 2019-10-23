import clasesBase.*
import wollok.game.*
import metaActores.*

class Rana {

	
	var property position = game.at(2, 1)
	var property vidas = 3
	var property puntos = 0
	var property otraRana // TODO: Otra alternativa?
	const property posicionInicial = game.at(2, 1)
	const property nombreSprite
	var direccion = arriba
	

	method image() = nombreSprite + "/" + direccion.nombre() + ".png"

	method laOtraRanaEstaEnPosicion(posicion) = game.getObjectsIn(posicion).contains(otraRana)

	method tratarDeMoverseEnDireccion(direccionAMoverse) {
		direccion = direccionAMoverse
		const posicionADondeMoverse = direccionAMoverse.proximaPosicionDirecta(position)
		if (self.laOtraRanaEstaEnPosicion(posicionADondeMoverse)) {
			otraRana.tratarDeMoverseEnDireccion(direccionAMoverse)
		}
		if (!self.posicionEstaAfuera(posicionADondeMoverse) and !self.laOtraRanaEstaEnPosicion(posicionADondeMoverse)) {
			position = posicionADondeMoverse
		}
	}

	method cambiarPosicionForzado(posicion) { // TODO: cambiar nombre
		if (!self.posicionEstaAfuera(posicion)) {
			position = posicion
		} else {
			self.morir()
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

	method volverAlInicio() {
		direccion = arriba
		position = posicionInicial
	}

	method morir() {
		if (vidas != 0) {
			vidas--
				// TODO: Aca hacer la animacion de la muerte
			self.volverAlInicio()
		} else {
			game.stop()
		}
	}

	method ganar() {
		puntos++
		self.volverAlInicio()
	}

	/*TODO: Tiene que haber una contador visual de vidas, entonces tiene que haber un objeto que minimamente
	 * represente visualmente las vidas. Pero si vamos a hacer un objeto de vidas, no tendriamos
	 * que hacer ese objeto maneje las vidas en vez de la rana? Para pensar.
	 */
	method colisionarConUnaRana(unaRana) {
		game.sound("croak.mp3")
	}

	method empujarse(posicionASerEmpujado) {
	}
	
	method ganarDefinitivo(){
		
	}

}

class Tronco inherits Montable {

	const proximoTronco

	override method moverse() {
		super()
		proximoTronco.moverse()
	}

}

class Agua {

	const property position
	const property image = "nada.png"

	method colisionarConUnaRana(unaRana) {
		if (game.getObjectsIn(position).size() == 2) { // TODO: por favor hacer esto de una forma no horrible. Ahora se checkea que si al colisionar solo hay 2 cosas (rana y agua) 
			unaRana.morir()
		}
	}

}

class Meta {

	const property position
	var property image = "nada.png"
	var puntoEstaTomado = false

	method colisionarConUnaRana(unaRana) {
		if (!puntoEstaTomado) {
			image = unaRana.nombreSprite() + "/" + "bigBoy" + ".png"
			unaRana.ganar()
			puntoEstaTomado = true
			victoryManager.checkearVictoria()
		}else{
			unaRana.morir()
		}
	}

}

object troncoNulo {

	method moverse() {
	}

}

