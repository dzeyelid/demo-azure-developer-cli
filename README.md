# Azure Developer CLI デモ

[Global Azure 2023](https://jazug.connpass.com/event/279068/)で発表するセッションのために作成したデモのプロジェクトです。

なお、Azure Developer CLIは現在プレビュー中のため、今後仕様が変更される可能性があります。

## Azure Developer CLIとは

Azureを利用して構築されるアプリケーションへのデプロイと開発サイクルをサポートする、開発者のためのCLIです。

もともと提供されているAzure CLI（`az`）はAzureのリソースを操作するためのCLIであることに対し、Azure Developer CLI（`azd`）はアプリケーション コードのビルドやデプロイを一貫して操作できます。

## `azd`でできること

- Azureリソースのデプロイ
- アプリケーション コードのビルド
- アプリケーション コードのデプロイ
- **テンプレート**による`azd`環境の構築

### サポートされる言語とホスト

`azd`は、下記の環境をサポートしています。

#### サポートされる言語
- C#
- F#
- Python
- JavaScript/TypeScript
- Java

#### サポートされるホスト

- Azure App Service
- Azure Functions
- Azure Static Web Apps
- Azure Container Apps
- Azure Kubernetes Service

## 開発者向け

### `azd`コマンドを利用するには

`azd`コマンドを利用するには、実行環境のインストールとテンプレートが必要です。これは「[`azd`を利用できる環境を構築する](#azdを利用できる環境を構築する)」にて後述します。

### 開発者向けコマンド

開発者が利用する`azd`のコマンドは下記の通りです。

| コマンド | 説明 |
|----|----|
| `azd auth login` | 利用するAzureにログインする |
| `azd up` | `package`（ビルドとパッケージング）, `provision`（Azureリソースの構築）, `deploy`（デプロイ）の工程を1ステップで行う |
| `azd deploy` | アプリケーション コードのデプロイを行う |
| `azd down` | `provision`で構築した環境を削除する |
| `azd env` | 環境を管理する |
| `azd monitor` | デプロイしたアプリケーションのモニタリングリソースを開く |
| `azd pipeline` | `azd`テンプレートを利用する際に、パイプラインに必要な設定を行う |

`azd up`コマンドを実行すると、環境の名前の入力を求められます。環境は複数作成でき、用途によって切り替えられます。

### 作業の流れ

プロジェクトの開始時は、下記のようにログインと環境の立ち上げを行います。`azd up`では、環境の作成や、Azureサブスクリプションの選択などをインタラクティブに操作できます。（デモ時は[下記コマンドにて代用](#デモ用コマンド)）

```bash
# Azureにログインする
azd auth login

# Azureリソースのデプロイ、アプリケーションのデプロイを行う
azd up
```

モニタリングツールを確認したい場合は、`azd monitor`コマンドを利用します。

```bash
azd monitor --live
```

アプリケーション コードの更新を反映したい場合は、`azd deploy`コマンドを実行します。

```bash
azd deploy
```

Azureリソースが不要になったら、`azd down`コマンドで削除します。（ローカルの作業内容には影響はありません）

```bash
azd down
```

#### デモ用コマンド

macOSでデモを行う場合、下記コマンドで代用する。

```bash
# Azureにログインする（※1）
azd auth login --use-device-code

# デモ用の環境を作成（※2）
azd env new --subscription {subscription id}

# 環境を立ち上げる
azd up
```

- ※1 `azd auth login`は、GitHub CodespacesとmacOSの相性により、device code loginを利用します。
- ※2 `azd up`で環境の設定やサブスクリプションの選択も行えるが、デモで不要なサブスクリプションなどをお見せしたくないため、先に指定します。

## `azd`を利用できる環境を構築する

### `azd`のインストール

Windows, Linux, macOSで利用できます。詳しくは下記のドキュメントをご参照ください。

- [Azure Developer CLIをインストールする (プレビュー) | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/developer/azure-developer-cli/install-azd)

なお、Linuxで利用する場合、`xdg-utils`が必要です。（`azd auth login`で必要）

### テンプレートを整備する人向けコマンド

| コマンド | 説明 |
|----|----|
| `azd template` | 公式テンプレートを確認する |
| `azd init` | 豊富な公式テンプレートから、もしくはスクラッチで`azd`テンプレートの初期化を行う |

## `azd`テンプレートを作成する

### ディレクトリ構成

### 最小限（Bicep）

```
├── .github                    [ GitHub設定ディレクトリ ]
│   ├── workflows              [ GitHub Actionsのワークフローディレクトリ ]
│   │   └── {workflow}.yml     [ GitHub Actionsのワークフローファイル ]
├── infra                      [ インフラストラクチャ コードを格納するディレクトリ ]
│   ├── main.bicep             [ Bicepのコード ]
│   ├── main.parameters.json   [ Bicepのパラメーターファイル ]
│   ├── app                    [ 機能ごとのモジュールを格納するディレクトリ ]
│   └── core                   [ 共通で利用するモジュールを格納するディレクトリ ]
├── src                        [ アプリケーション コードを格納するディレクトリ ]
│   ├── …
│   └── {service}              [ サービスごとのディレクトリ ]
└── azure.yaml                 [ azdテンプレートの構成ファイル ]
```

#### `src`ディレクトリの構成

`src`ディレクトリ配下は、`azure.yaml`で指定したサービスごとにディレクトリを構成すると見通しがよいです。

#### `infra`ディレクトリの構成

`infra`ディレクトリには、起点としての`main.bicep`とパラメーターファイル`main.parameters.json`を配置します。

また、モジュールを配置するために`app`と`core`ディレクトリが推奨されており、`app`には機能ごとに仕分けたいモジュールを、`core`には共通で利用するモジュールを配置します。

### `azure.yml`の構成

参考に、このプロジェクトの[azure.yaml](./azure.yaml)を示します。これは最小限の構成で、`api`というサービスを持ち、その言語やホストが指定されています。

```yaml
name: demo-azure-developer-cli  # テンプレートの名前
services:                       # サービス一覧
  api:                          # サービスの名前
    project: src/api            # サービスに対応するアプリケーション コードを格納しているディレクトリ
    language: ts                # アプリケーションを記述している言語
    host: function              # アプリケーションをホストする対象
```

詳細は、下記のドキュメントをご参照ください。

- [Azure Developer CLIの azure.yaml スキーマ | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/developer/azure-developer-cli/azd-schema)

### サービスとAzureリソースの紐づけの仕組み

`azd`で扱うAzureリソースは、タグによって紐づけがなされます。環境ごとに区別できるよう、扱うリソースには下記のタグを付与します。

| タグ名 | 説明 |
|----|----|
| `azd-env-name` | `azd env`で構成する環境の名前 |

また、サービスを区別できるよう、対象のホスト リソースには下記のタグを付与します。

| タグ名 | 説明 |
|----|----|
| `azd-service-name` | `azure.yaml`の`services`で指定したサービス名 |

適切なタグが設定されていない場合は、`azd`の命名規則に従ったリソースが対象になります。詳細は下記ドキュメントをご参照ください。

- [Bicep ファイルを追加する - プロジェクトをAzure Developer CLI (プレビュー) と互換性のあるものにする | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/developer/azure-developer-cli/make-azd-compatible?pivots=azd-create#add-bicep-files)
- [`services` プロパティ - Azure Developer CLIの azure.yaml スキーマ | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/developer/azure-developer-cli/azd-schema#services-properties)

### パイプラインを構成する際のポイント

#### Azureへの認証

利用者によって`azd pipeline config`が実行されると、CLIはAzureへの認証を確立し、その接続情報をsecretsまたはvariablesを設定します。

この`azd pipeline config`で`--auth-type`フラグに`federated`に指定すると、OpenID Connect(OIDC)による認証方法で構成され、GitHubリポジトリのActions用Variablesに`AZURE_CLIENT_ID`,`AZURE_SUBSCRIPTION_ID`,`AZURE_TENANT_ID`が設定されます。ワークフローではこれらを用いてAzureに接続することができます。

### モニタリングに関する対応

利用者が`azd monitor --overview`でダッシュボードを開けるようにするには、ダッシュボード`Microsoft.Portal/dashboards`のリソースが必要です。

## 所感

- Azureリソースをデプロイするには、`az deployment`コマンドだったり、`terraform`コマンドだったりと開発では使わない操作が必要で手間や学習コストがかかるが、`azd`コマンドで一貫して扱える。
- Azureリソースの構成とアプリケーション コードの関連付けは、現状、環境変数やシェルスクリプトを利用してなんとかしているが、これを`azd`の構成に落とし込んで統合して管理できそう。
- Azureリソースとアプリケーション コードの管理を`azure.yaml`とディレクトリ構成で統一でき、プロジェクト全体の見通しがよくなる。
- デモやハンズオン、学習用の環境を作って利用してもらうのにすごく便利そう！🧑🏻‍🎓
- [GitHub Codespaces](https://github.com/features/codespaces)/[Dev container](https://code.visualstudio.com/docs/devcontainers/containers)による環境構築と相性抜群！🚀
