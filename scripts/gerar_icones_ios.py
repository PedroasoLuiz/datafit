"""Gera todos os tamanhos do AppIcon.appiconset do iOS a partir de um PNG fonte.

Uso:
    python scripts/gerar_icones_ios.py CAMINHO_DO_ICONE_1024.png

A fonte deve ser quadrada e idealmente 1024x1024. O script:
  - achata transparencia sobre branco (a Apple REJEITA icone com canal alpha)
  - avisa se a fonte for menor que 1024 (upscale = risco de reprovacao)
  - grava os 15 arquivos do iconset

Depois de rodar, conferir a divergencia contra o icone do Android com:
    python scripts/gerar_icones_ios.py --conferir
"""

import os
import sys

from PIL import Image

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ICONSET = os.path.join(
    RAIZ, "datafit", "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset"
)
ANDROID_ICON = os.path.join(
    RAIZ, "datafit", "android", "app", "src", "main", "res",
    "mipmap-xxxhdpi", "ic_launcher.png",
)

# (nome do arquivo, lado em px) — conforme o Contents.json padrao do Flutter
TAMANHOS = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]


def divergencia(a_path, b_path, lado=192):
    a = Image.open(a_path).convert("RGB").resize((lado, lado))
    b = Image.open(b_path).convert("RGB").resize((lado, lado))
    pa, pb = a.load(), b.load()
    total = sum(
        sum(abs(x - y) for x, y in zip(pa[i, j], pb[i, j]))
        for i in range(lado)
        for j in range(lado)
    )
    return total / (lado * lado * 3 * 255) * 100


def conferir():
    ios = os.path.join(ICONSET, "Icon-App-1024x1024@1x.png")
    d = divergencia(ios, ANDROID_ICON)
    print("Divergencia iOS vs Android: %.2f%%" % d)
    print("OK" if d < 5 else "ATENCAO: icones diferentes — risco de rejeicao")
    return 0


def gerar(origem):
    src = Image.open(origem)
    print("Fonte:", origem, src.size, src.mode)

    if src.width != src.height:
        print("ERRO: a imagem precisa ser quadrada.")
        return 1
    if src.width < 1024:
        print(
            "AVISO: fonte tem %dpx, menor que 1024. O upscale vai borrar e a "
            "Apple pode reprovar por qualidade de icone." % src.width
        )

    # Achata alpha sobre branco — icone da App Store nao pode ter transparencia.
    if src.mode in ("RGBA", "LA", "P"):
        src = src.convert("RGBA")
        fundo = Image.new("RGB", src.size, (255, 255, 255))
        fundo.paste(src, mask=src.split()[-1])
        src = fundo
        print("Canal alpha achatado sobre branco.")
    else:
        src = src.convert("RGB")

    os.makedirs(ICONSET, exist_ok=True)
    for nome, lado in TAMANHOS:
        src.resize((lado, lado), Image.LANCZOS).save(
            os.path.join(ICONSET, nome), "PNG", optimize=True
        )
        print("  %-32s %dx%d" % (nome, lado, lado))

    print("\n%d arquivos gravados em:\n  %s" % (len(TAMANHOS), ICONSET))
    if os.path.exists(ANDROID_ICON):
        print("\nDivergencia vs Android: %.2f%%" % divergencia(
            os.path.join(ICONSET, "Icon-App-1024x1024@1x.png"), ANDROID_ICON))
    return 0


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    sys.exit(conferir() if sys.argv[1] == "--conferir" else gerar(sys.argv[1]))
