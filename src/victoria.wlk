import constructores.*

object victoriaEstandar { // Hay victoria si hay una rana con suficientes puntos para ganar directo

	method hayVictoria() = controladorDeVictorias.algunaRanaGano()

}

object victoriaPorPuntosRestantes { // Si no quedan ranas vivas, hay alguna victoria (asumiendo que no hay empate)

	method hayVictoria() = controladorDeVictorias.ranasVivas().size() == 0

}

object victoriaPorDefault { // Si queda una rana viva y tiene mas puntos que la(s) muerta(s), hay victoria

	method quedaUnaSolaRanaViva() = controladorDeVictorias.ranasVivas() == 1

	method algunaRanaVivaEsPuntera() {
		const ranasVivas = controladorDeVictorias.ranasVivas()
		const unaRanaViva = ranasVivas.anyOne()
		return unaRanaViva == controladorDeVictorias.ranaPuntera()
	}

	method hayVictoria() = self.quedaUnaSolaRanaViva() and self.algunaRanaVivaEsPuntera()

}

object controladorDeVictorias {

	const ranas = []
	const puntosNecesariosParaGanar = 3

	method ranaEsGanadoraDefinitiva(unaRana) = unaRana.puntos() >= puntosNecesariosParaGanar

	method ranaPuntera() = ranas.max({ unaRana => unaRana.puntos() }) // Se asume que no hay empate

	method algunaRanaGano() = ranas.any({ unaRana => self.ranaEsGanadoraDefinitiva(unaRana) })

	method puntosDeRanas() = ranas.map({ unaRana => unaRana.puntos() })

	method vanEmpatando() {
		const puntosMaximos = self.puntosDeRanas().max()
		return self.puntosDeRanas().occurrencesOf(puntosMaximos) > 1 // Osea si la cantidad maxima de puntos aparece mas de 1 vez, es que hay 2 ranas empatando
		// Igualmente no es como que si alguna vez van a haber mas de 2 ranas pero ok.
	}

	method ranasVivas() = ranas.filter({ unaRana => unaRana.estaViva() })

	method seCumpleAlgunaCondicionDeVictoria() {
		const metodosDeVictoria = [ victoriaEstandar, victoriaPorDefault, victoriaPorPuntosRestantes ]
		return metodosDeVictoria.any({ unMetodo => unMetodo.hayVictoria() })
	}

	method hayAlgunaVictoria() = !self.vanEmpatando() and self.seCumpleAlgunaCondicionDeVictoria()

	method todasLasMetasEstanOcupadas() {
		const cantidadDeMetas = 4
		return self.puntosDeRanas().sum() == cantidadDeMetas
	}

	method todasLasRanasEstanMuertas() {
		return ranas.all({ unaRana => !unaRana.estaViva() })
	}

	method elJuegoNoPuedeSeguir() = self.todasLasMetasEstanOcupadas() or self.todasLasRanasEstanMuertas()

	method hayEmpateDefinitivo() = self.elJuegoNoPuedeSeguir() and self.vanEmpatando()

	method checkearVictoria() {
		if (self.hayAlgunaVictoria()) {
			self.victoriaParaRanaPuntera()
		} else if (self.hayEmpateDefinitivo()) {
			self.tirarEmpate()
		}
	}

	method victoriaParaRanaPuntera() {
		const ranaPuntera = self.ranaPuntera()
		ranas.clear()
		ranaPuntera.ganarDefinitivo()
		
	}

	method tirarEmpate() {
		ranas.clear()
		generadorDelMundo.reiniciarMundo()
		
	}

	method agregarRana(unaRana) {
		ranas.add(unaRana)
	}

}
