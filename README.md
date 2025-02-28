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
        MadridInGameiOSModule(
            email: "test@test.com", 
            userName: "Test", 
            dni: "00000000R", 
            accessToken: "The Acces Token", 
            logoMIG: logoMIG, 
            qrMiddleLogo: qrMiddleLogo
        )
    }
}
```
Parámetros: (All Required*)

- email: String -> El correo electrónico del usuario.
- userName: String -> El nombre de usuario.
- dni: String -> El DNI o documento de identidad del usuario.
- accessToken: String -> El token de acceso para la autenticación.
- logoMIG: UIImage -> Un logo de la aplicación (debe ser una imagen que se pase como parámetro).
- qrMiddleLogo: UIImage -> Un logo adicional que aparecerá en el centro del QR (también una imagen que se pasa como parámetro).


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

