# 🎯 2048 Game on AWS - 完全自動化 CI/CD パイプライン

## 📌 プロジェクト概要
このプロジェクトは、人気パズルゲーム「2048」を **Docker** でコンテナ化し、**AWS ECS Fargate** 上にデプロイするための **CI/CD パイプライン** を構築したものです。  
**GitHub Actions** と **Terraform** を活用し、コードのプッシュからビルド・デプロイまでの一連の流れを完全自動化しました。  
Terraform バックエンドには **HCP Terraform** を採用し、クラウド上での状態管理とチーム開発を容易にしています。

---

## 🖼 スクリーンショット

### ゲーム画面
![2048-game-screenshot](./images/game-screenshot.png)

URL: （通常公開停止中）

---

## 🛠 使用技術

| カテゴリ               | 技術内容 |
|------------------------|----------|
| Infrastructure as Code | Terraform（HCP Terraform Backend） |
| Cloud Provider       | AWS（VPC, ECS Fargate, ALB, ECR, IAM） |
| CI/CD                  | GitHub Actions（mainブランチへのpushで自動ビルド・デプロイ） |
| Container               | Docker（アプリケーションホスト） |

---

## 🚀 解決した課題と工夫した点

- **インフラ構築の自動化**  
  Terraform を用いて VPC / サブネット / セキュリティグループ / ECS / ALB / ECR をコード化し、手動操作による設定ミスを防止。
- **デプロイ時間の大幅短縮**  
  マネジメントコンソールでの手動構築・更新に比べ、デプロイ時間を約 **94% 短縮**（約90分 → 約5分）。
- **CI/CD パイプライン構築**  
  GitHub Actions により `main` ブランチへの push をトリガーに、Docker イメージビルド → ECR へ push → ECS サービス更新まで自動化。
- **環境差異の排除**  
  コンテナ技術を活用し、ローカル・ステージング・本番環境で同一挙動を実現。
- **HCP Terraform でのリモートステート管理**  
  S3 や DynamoDB の構築不要で、クラウド上に安全に Terraform の状態を保存。  
  バックエンド設定を簡素化し、複数端末からのアクセスやチームでのインフラ管理を効率化。

---

## 🏗 アーキテクチャ図
![architecture-diagram](./images/architecture-diagram.png)

---

## ⚙️ CI/CD ワークフロー概要
1. `main` ブランチへのpushをトリガー  
2. DockerイメージをビルドしてECRにプッシュ  
3. ECSタスク定義を更新  
4. ECSサービスをローリングアップデート  
5. ALB経由でアプリケーションを公開  

---

## 📂 ディレクトリ構成
```
.
├── .github/                        # GitHub関連設定
│   └── workflows/
│       └── deploy.yml             # GitHub Actions CI/CDワークフロー定義
│
├── backend-bootstrap/             # HCP terraform remote backend 設定用
├── js/                             # フロントエンド（2048ゲームロジック）
├── style/                          # CSSファイル群
├── index.html                      # ゲーム画面のHTML（静的ホスティング対象）
│
├── Dockerfile                      # NginxでゲームをホストするDockerイメージ定義
├── buildspec.yml                   # CodeBuild用ビルド定義（未使用なら削除可）
│
├── terraform/
│   ├── main.tf                     # メインのTerraform構成ファイル
│   ├── variables.tf                # 各種変数定義
│   ├── outputs.tf                  # 出力変数（ALB DNS名など）
│   ├── terraform.tfstate           # Terraformの状態ファイル（S3にリモート保存推奨）
│   ├── terraform.tfstate.backup    # 状態ファイルのバックアップ
│   ├── .terraform.lock.hcl         # プロバイダーのロックファイル
│
│   ├── modules/                    # 再利用可能なモジュール群
│   │   ├── alb/                    # ALB関連のリソース定義（ターゲットグループ等）
│   │   ├── ecr/                    # ECRリポジトリの定義
│   │   ├── ecs/                    # ECSクラスター・サービス・タスク定義など
│   │   ├── iam/                    # IAMロール・ポリシーの定義
│   │   ├── network/                # VPC・サブネット・ルートテーブルなど
│   │   └── security/              # セキュリティグループ定義
│
└── README.md                       # このプロジェクトの説明ファイル
```

---

## HCP Terraform 上での実行例

1. **New Run** を作成  
2. **Plan** を確認（変更点を GUI で可視化）  
3. 確認後 **Apply** を実行 

### HCP Terraform の利点

- **リソースや Outputs を GUI で一覧確認可能**  
  ![hcp-outputs](./images/hcp-outputs.png)
- **States の履歴管理・ロールバック** が容易  
  ![hcp-state-history](./images/hcp-state-history.png)
- **チームコラボレーション**（実行履歴や差分を共有）  
- **VCS 連携による自動 Plan / Apply**（例：GitHub）  
- **環境変数やシークレットの安全管理**  
- ローカル CLI 実行不要で **ブラウザから IaC 管理可能**

## 💡 今後の改善点
以下の点については、今後さらに改善していくことで、運用性や信頼性の向上が期待できると考えています：

- **HTTPS対応**  
  ACM証明書を利用してHTTPS通信を有効化することで、よりセキュアなアクセス環境を提供できると考えています。Route 53などを活用した独自ドメインの導入も検討したいです。

- **環境分離（dev / staging / prod）**  
  Terraform Workspaceやディレクトリの構成を工夫することで、複数環境に対応した柔軟な運用が可能になると考えています。

- **ログ監視の強化**  
  ECSタスクのログをCloudWatch Logsに出力することで、稼働状況やエラーの把握がしやすくなり、トラブルシューティングの効率向上が期待できます。

- **自動停止スケジュールの導入**  
  EventBridgeを使って夜間や非稼働時間帯にECSサービスを自動停止することで、無駄なリソース利用を抑え、コスト最適化が実現できる可能性があります。


---

## 🔁 ローカル環境での再現手順

### 前提条件
- AWS CLI & Terraform インストール済み
- AWS 認証情報設定済み（`aws configure` または環境変数）
- Docker インストール済み

---

### 手順例

```bash
# 1. リポジトリをクローン
git clone https://github.com/your-username/aws-2048-cicd-pipeline.git
cd aws-2048-cicd-pipeline

# 2. Terraform 初期化
terraform init

# 3. 実行プランの確認
terraform plan

# 4. 適用
terraform apply

# 5. 環境破棄
terraform destroy


---

## 作者 / Author

**Akito Ito**  
元 AWS Cloud Support Engineer（RDS / DMS）  
GitHub: [@nasu-dev](https://github.com/nasu-dev)

---

## ライセンス / License

This project is licensed under the MIT License.