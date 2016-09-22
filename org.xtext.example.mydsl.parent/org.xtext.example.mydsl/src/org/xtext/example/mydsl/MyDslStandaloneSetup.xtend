/*
 * generated by Xtext 2.10.0
 */
package org.xtext.example.mydsl

import com.google.inject.Injector
import org.eclipse.emf.ecore.EPackage

/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class MyDslStandaloneSetup extends MyDslStandaloneSetupGenerated {

	def static void doSetup() {
		new MyDslStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
	
	override register(Injector injector) {
		if (!EPackage.Registry.INSTANCE.containsKey(MydslPackage.eNS_URI)) {
			EPackage.Registry.INSTANCE.put(MydslPackage.eNS_URI, MydslPackage.eINSTANCE);
		}
		super.register(injector)
	}
	
}
