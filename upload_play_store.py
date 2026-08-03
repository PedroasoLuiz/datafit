import json
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

SERVICE_ACCOUNT_JSON = r"G:\Meu Drive\Virtus Tecnologias\VIRTUS - Utilitários\Assinatura GPS GooglePlay\encoded-keyword-457822-n0-40579a0576b1.json"
AAB_PATH = r"C:\Users\pedro\Documents\datafit\datafit\build\app\outputs\bundle\release\app-release.aab"
PACKAGE_NAME = "com.virtus.datafit"
TRACK = "internal"

credentials = service_account.Credentials.from_service_account_file(
    SERVICE_ACCOUNT_JSON,
    scopes=["https://www.googleapis.com/auth/androidpublisher"],
)

service = build("androidpublisher", "v3", credentials=credentials)

print("Criando edit...")
edit = service.edits().insert(packageName=PACKAGE_NAME, body={}).execute()
edit_id = edit["id"]
print(f"Edit criado: {edit_id}")

print("Fazendo upload do AAB...")
media = MediaFileUpload(AAB_PATH, mimetype="application/octet-stream", resumable=True)
bundle = service.edits().bundles().upload(
    packageName=PACKAGE_NAME,
    editId=edit_id,
    media_body=media,
).execute()
version_code = bundle["versionCode"]
print(f"AAB enviado. Version code: {version_code}")

print(f"Atribuindo ao track '{TRACK}'...")
service.edits().tracks().update(
    packageName=PACKAGE_NAME,
    editId=edit_id,
    track=TRACK,
    body={
        "track": TRACK,
        "releases": [
            {
                "versionCodes": [str(version_code)],
                "status": "draft",
            }
        ],
    },
).execute()
print("Track atualizado.")

print("Commitando edit...")
result = service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
print(f"Sucesso! Edit commitado: {result}")
