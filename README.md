## README.md

# MadridInGameModule

MadridInGameModule es un framework desarrollado en Swift que proporciona componentes y funcionalidades avanzadas para integrar experiencias de juego interactivas en aplicaciones iOS.

## Características

- **Dropdowns**: Componentes personalizables para selecciones simples y múltiples.
- **Calendario**: Vista de calendario interactiva para manejar eventos.
- **Gestión de Equipos**: Componentes para crear y gestionar equipos.
- **Reservas**: Gestión de reservas individuales y en equipo.
- **Popups y Componentes Personalizados**: Elementos visuales reutilizables y altamente configurables.

## Requisitos

- iOS 13.0 o superior
- Swift 5.0 o superior

## Instalación

### CocoaPods

Para integrar **MadridInGameModule** en tu proyecto usando CocoaPods, añade la siguiente línea a tu `Podfile`:

```ruby
pod 'MadridInGameModule'
```

Luego, ejecuta:

```bash
pod install
```

## Uso

### Importar el módulo

```swift
import MadridInGameModule
```

### Ejemplo básico

#### Crear un Dropdown

```swift
let dropdown = DropdownComponentView()
dropdown.items = ["Opción 1", "Opción 2", "Opción 3"]
dropdown.didSelectItem = { selectedItem in
    print("Seleccionaste: \(selectedItem)")
}
```

#### Mostrar un Calendario

```swift
let calendarView = CustomCalendarView()
calendarView.onDateSelected = { date in
    print("Fecha seleccionada: \(date)")
}
```

## Ejemplo completo

Revisa el proyecto de ejemplo en la carpeta `Example/` para ver implementaciones más detalladas.

## Contribuciones

¡Las contribuciones son bienvenidas! Por favor, crea un pull request o abre un issue en el repositorio para discutir mejoras.

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

