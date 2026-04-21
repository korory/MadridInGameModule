//
//  DetailsRulesView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 31/3/25.
//

import SwiftUI
import PDFKit

struct DetailsRulesView: View {
    var title: String
    var rulesText: String?
    var pdfFile: String?
    var environmentManager = EnvironmentManager()

    @State private var isDownloading = false
    @State private var downloadedFileURL: URL? = nil
    @State private var showShareSheet = false
    @State private var expandedSection: RulesSection? = nil

    enum RulesSection { case text, pdf }

    private var hasText: Bool {
        guard let text = rulesText else { return false }
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var pdfURL: URL? {
        guard let pdfFile, !pdfFile.isEmpty else { return nil }
        return URL(string: "\(environmentManager.getBaseURL())/assets/\(pdfFile)")
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)

            contentLayout
        }
        .sheet(isPresented: $showShareSheet) {
            if let fileURL = downloadedFileURL {
                ShareSheet(items: [fileURL])
            }
        }
    }

    private var ruleItems: [(icon: String, text: String)] {
        [
            ("smoke.fill",         "rule.smoke_free".localized),
            ("fork.knife",         "rule.no_food".localized),
            ("figure.run",         "rule.no_running".localized),
            ("speaker.slash.fill", "rule.respect_environment".localized),
            ("trash.fill",         "rule.keep_clean".localized),
            ("xmark.icloud.fill",  "rule.no_downloads".localized)
        ]
    }

    // MARK: - Content layout

    @ViewBuilder
    private var contentLayout: some View {
        if let url = pdfURL {
            // Accordion: rules grid + PDF
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    titleRow
                        .padding(.top, 5)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

                    accordionHeader(
                        label: "rules.section.text".localized,
                        icon: "doc.text",
                        isExpanded: expandedSection == .text
                    ) {
                        withAnimation(.easeInOut(duration: 0.22)) {
                            expandedSection = expandedSection == .text ? nil : .text
                        }
                    }

                    if expandedSection == .text {
                        rulesGrid
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    Divider()
                        .background(Color.white.opacity(0.15))
                        .padding(.horizontal, 20)

                    accordionHeader(
                        label: "rules.section.pdf".localized,
                        icon: "doc.richtext",
                        isExpanded: expandedSection == .pdf
                    ) {
                        withAnimation(.easeInOut(duration: 0.22)) {
                            expandedSection = expandedSection == .pdf ? nil : .pdf
                        }
                    }

                    if expandedSection == .pdf {
                        PDFReaderView(url: url)
                            .frame(height: 460)
                            .padding(.top, 8)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .animation(.easeInOut(duration: 0.22), value: expandedSection)
            }
        } else {
            // No PDF: show grid directly
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    titleRow
                        .padding(.top, 5)
                        .padding(.horizontal, 20)
                    rulesGrid
                        .padding(.horizontal, 16)
                }
                .padding(.bottom, 20)
            }
        }
    }

    private var rulesGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2),
            spacing: 12
        ) {
            ForEach(ruleItems, id: \.text) { item in
                RuleCell(icon: item.icon, text: item.text)
            }
        }
    }

    // MARK: - Accordion header

    private func accordionHeader(label: String, icon: String, isExpanded: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(.cyan)
                Text(label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Rule cell

    private struct RuleCell: View {
        let icon: String
        let text: String

        var body: some View {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 22, alignment: .center)
                Text(text)
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)
        }
    }

    // MARK: - Title row

    private var titleRow: some View {
        HStack(alignment: .center) {
            Text(title.uppercased())
                .font(.madridInGameiOSFont(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()

            if pdfURL != nil {
                Button {
                    Task { await downloadPDF() }
                } label: {
                    HStack(spacing: 6) {
                        if isDownloading {
                            ProgressView()
                                .tint(.black)
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.down.to.line")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        Text("pdf.download".localized)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.cyan)
                    .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isDownloading)
            }
        }
    }

    // MARK: - Download

    private func downloadPDF() async {
        guard let url = pdfURL else { return }
        isDownloading = true
        defer { isDownloading = false }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let filename = (response.suggestedFilename ?? "rules.pdf")
            let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
            try data.write(to: tmpURL)
            downloadedFileURL = tmpURL
            showShareSheet = true
        } catch {
            // Silent fail — share sheet simply won't open
        }
    }
}

// MARK: - Share sheet

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - PDF Reader

private struct PDFReaderView: View {
    let url: URL
    @State private var pdfDocument: PDFDocument? = nil
    @State private var isLoading = true
    @State private var loadFailed = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .tint(.cyan)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if loadFailed || pdfDocument == nil {
                Text("No se pudo cargar el documento.".localized)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
            } else {
                PDFKitView(document: pdfDocument!)
            }
        }
        .task {
            await loadPDF()
        }
    }

    private func loadPDF() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let doc = PDFDocument(data: data) {
                pdfDocument = doc
            } else {
                loadFailed = true
            }
        } catch {
            loadFailed = true
        }
        isLoading = false
    }
}

// MARK: - PDFKit UIViewRepresentable

private struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .clear
        pdfView.document = document
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = document
    }
}
