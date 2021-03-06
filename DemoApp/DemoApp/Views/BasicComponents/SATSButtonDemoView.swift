import SwiftUI

struct SATSButtonDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack {
                    Text("Large")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    demoButton(style: .primary, size: .large)

                    demoButton(style: .secondary, size: .large)

                    demoButton(style: .clean, size: .large)

                    demoButton(style: .cta, size: .large)

                }

                VStack {
                    Text("Basic")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    demoButton(style: .primary, size: .basic)

                    demoButton(style: .secondary, size: .basic)

                    demoButton(style: .clean, size: .basic)

                    demoButton(style: .cta, size: .basic)

                }

                VStack {
                    Text("Compact")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    demoButton(style: .primary, size: .compact)

                    demoButton(style: .secondary, size: .compact)

                    demoButton(style: .clean, size: .compact)

                    demoButton(style: .cta, size: .compact)
                }

                VStack {
                    Text("Loading")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    demoButton(style: .primary, size: .large, shouldLoad: true)

                    demoButton(style: .secondary, size: .large, shouldLoad: true)

                    demoButton(style: .clean, size: .large, shouldLoad: true)

                    demoButton(style: .cta, size: .large, shouldLoad: true)

                    demoButton(style: .primary, size: .basic, shouldLoad: true)

                    demoButton(style: .secondary, size: .basic, shouldLoad: true)

                    demoButton(style: .clean, size: .basic, shouldLoad: true)

                    demoButton(style: .cta, size: .basic, shouldLoad: true)
                }

                Spacer()
                    .layoutPriority(1)
            }
            .padding()
            .navigationTitle("SATSButton")
        }
    }

    func demoButton(style: SATSButton.Style, size: SATSButton.Size, shouldLoad: Bool = false) -> some View {
        let button = SATSButton(style: style, size: size, withAutoLayout: false)
        button.setTitle(style.name, for: .normal)
        if shouldLoad {
            button.startLoader()
        }
        return DemoWrapperView(view: button)
    }
}

struct SATSButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ColorTheme.current = .blue

        return NavigationView {
            SATSButtonDemoView()
        }
    }
}
