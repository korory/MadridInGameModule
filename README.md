## README.md


# MadridInGameiOSModule

## Requisitos

- iOS 13.0 o superior
- Swift 5.0 o superior

## Instalación

### CocoaPods

Para integrar **MadridInGameiOSModule** en tu proyecto usando CocoaPods, añade la siguiente línea a tu `Podfile`:

```ruby
pod 'MadridInGameiOSModule'
```

Luego, ejecuta:

```bash
pod install
```

### Uso

### Importar el módulo
Para comenzar a usar MadridInGameiOSModule, importa el módulo en tu archivo Swift:

```swift
import MadridInGameiOSModule
```


### Ejemplo básico

#### Instanciar el modulo

```swift
struct ContentView: View {
    var body: some View {
      
        // Opción 1: Inicializar usando la estructura [translate:MadridInGameModel]
        let model = MadridInGameModel(
            name: "Nombre",
            lastName: "Apellido",
            userName: "Test",
            email: "test@test.com",
            dni: "00000000R",
            phone: "600000000",
            accessToken: "El Token de Acceso",
            logoMIG: logoMIG,
            qrMiddleLogo: qrMiddleLogo
        )
        
        // Lanzar el módulo usando el objeto model
        MadridInGameiOSModule(model)
        
        // Opción 2: Inicializar el módulo pasando los parámetros individualmente
        MadridInGameiOSModule(
            email: "test@test.com",
            userName: "Test",
            dni: "00000000R",
            accessToken: "El Token de Acceso",
            logoMIG: logoMIG,
            qrMiddleLogo: qrMiddleLogo
        )
    }
}
```

### Parámetros de MadridInGameiOSModule (Todos obligatorios*)

- **email: String**
El correo electrónico del usuario.
- **userName: String**
El nombre de usuario.
- **dni: String**
El DNI o documento de identidad nacional del usuario.
- **accessToken: String**
El token de acceso utilizado para la autenticación.
- **logoMIG: UIImage**
El logo de la aplicación que se mostrará o usará. Debe pasarse como un objeto `UIImage`.
- **qrMiddleLogo: UIImage**
Un logo adicional que aparecerá centrado en el código QR. También debe pasarse como un objeto `UIImage`.


### Parámetros del modelo MadridInGameModel (Todos opcionales excepto los indicados)

- **name: String?**
El nombre del usuario.
- **lastName: String?**
El apellido del usuario.
- **userName: String**
El nombre de usuario.
- **email: String**
El correo electrónico del usuario.
- **dni: String?**
El DNI o documento de identidad del usuario.
- **phone: String?**
El teléfono de contacto del usuario.
- **accessToken: String**
El token de acceso para la autenticación.
- **logoMIG: UIImage?**
El logo de la aplicación que se mostrará o usará.
- **qrMiddleLogo: UIImage?**
Un logo adicional que aparecerá centrado en el código QR.

### Notas

- Puede inicializar el módulo pasando una instancia completa de MadridInGameModel o proporcionando cada parámetro por separado.

## Licencia

MadridInGameModule está licenciado bajo la [MIT License](LICENSE).

---

## LICENSE

MIT License

Copyright (c) 2024 Madrid In Game

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

