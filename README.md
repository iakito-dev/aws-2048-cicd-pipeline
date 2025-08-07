# 2048 Game on AWS - Fully Automated CI/CD Pipeline

このプロジェクトでは、2048ゲーム（静的Webアプリ）を **AWS ECS Fargate** 上にホストし、**GitHub Actions** による自動デプロイパイプラインを構築しました。  
インフラ構築からアプリケーションのデプロイまでを完全自動化することで、手作業によるミスや遅延を防ぎ、再現性と効率性を大幅に向上させました。

---

## 概要 / Overview

- **目的**  
  手動デプロイの作業負担やヒューマンエラーのリスクを削減するため、IaCとCI/CDを活用して信頼性の高いデプロイ基盤を構築しました。

- **解決した課題**  
  - AWSマネジメントコンソールによる手動構築・更新の非効率さと設定ミスのリスクを解消  
  - ECSのタスク定義やサービス更新で発生しがちなミスを排除  
  - コンテナ技術を用いて環境差異によるトラブルシューティングの手間を削減

---

## 成果 / Outcomes

- デプロイ時間を約**94%短縮**（手動約90分 → 自動約5分）
- ECRへのイメージプッシュからECSサービス更新までの流れを完全自動化
- `terraform apply` 一発でVPC〜ALB〜ECS〜ECR〜IAMを一貫構築
- ローカルとGitHub上の両方で同一環境を再現可能
- **TerraformのステートファイルをS3に保存し、DynamoDBによるロック管理も導入**  
  → チーム運用や並行作業時の整合性も確保できるように工夫しました

---

## デモ画像 / Demo Screenshot

<!-- スクリーンショットをここに挿入予定（例: ![screenshot](./images/demo.png)） -->

---

## 使用技術 / Tech Stack

| カテゴリ              | 技術内容                                                              |
|-----------------------|-----------------------------------------------------------------------|
| Infrastructure as Code| Terraform（S3 backend + DynamoDB Locking）                            |
| Cloud Provider        | AWS（VPC, Subnet, ECS Fargate, ALB, ECR, IAM, S3, DynamoDB）           |
| CI/CD                 | GitHub Actions（mainブランチへのpushで自動ビルド・デプロイ）          |
| Container             | Docker（2048ゲームをNginxでホスティング）                             |
| Network               | パブリックサブネット + ALB + セキュリティグループによる分離構成       |

---

## 前提条件 / Prerequisites

このプロジェクトを動作させるためには、以下の環境が必要です：

- **ローカル環境に以下がインストールされていること：**  
  - Docker  
  - Terraform  
  - AWS CLI（`aws configure`で認証設定済み）  

- **GitHub Secrets に以下の環境変数を設定する必要があります：**  
  - `AWS_ACCESS_KEY_ID`  
  - `AWS_SECRET_ACCESS_KEY`  

---

## 構成図 / Architecture

```
GitHub
└── GitHub Actions
    ├── Docker build & push to ECR
    ├── ECS Task Definition 更新
    ├── ECS Service 更新（Fargate）
    └── ALB 経由で公開（HTTP）
```

<!-- 必要に応じて構成図のスクリーンショットやMermaid図をここに追加 -->

---

## セットアップ手順 / Getting Started

```bash
# リポジトリをクローン
git clone https://github.com/nasu-dev/aws-2048-cicd-pipeline.git
cd aws-2048-cicd-pipeline

# Terraform 初期化とインフラ構築
terraform init
terraform apply
```

---

## 動作確認 / Verification

`terraform apply` の出力に表示される ALB の DNS名にアクセスすると、2048ゲームが正しく表示されることを確認できます。

---

## ディレクトリ構成 / Directory Structure

```
.
├── .github/                        # GitHub関連設定
│   └── workflows/
│       └── deploy.yml             # GitHub Actions CI/CDワークフロー定義
│
├── backend-bootstrap/             # Terraform backend（S3バケットやDynamoDB）作成用
│
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

## CI/CD フロー / CI/CD Workflow

`.github/workflows/deploy.yml` により、以下の自動デプロイフローを構築しました：

1. `main` ブランチへのpushをトリガー  
2. DockerイメージをビルドしてECRにプッシュ  
3. ECSタスク定義を更新  
4. ECSサービスをローリングアップデート  
5. ALB経由でアプリケーションを公開  

※ GitHub Secrets に以下の環境変数を事前に設定しておく必要があります：

- `AWS_ACCESS_KEY_ID`  
- `AWS_SECRET_ACCESS_KEY`  

---

## 今後の改善点 / Future Improvements

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

## リンク / Links

- デプロイ済みURL（ALB）: http://2048-game-alb-1651277876.ap-northeast-1.elb.amazonaws.com  
- GitHub リポジトリ: [https://github.com/nasu-dev/aws-2048-cicd-pipeline](https://github.com/nasu-dev/aws-2048-cicd-pipeline)

---

## 作者 / Author

**Akito Ito**  
元 AWS Cloud Support Engineer（RDS / DMS）  
GitHub: [@nasu-dev](https://github.com/nasu-dev)

---

## ライセンス / License

This project is licensed under the MIT License.
