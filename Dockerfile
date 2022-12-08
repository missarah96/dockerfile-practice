name: Publish Dockerfile on DockerHub
on: 
  push: 
    branches:
      - main
    paths: 
      - 'Dockerfile'
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
      with:
        fetch-depth: '0'
    - name: Bump version and push tag
      uses: anothrNick/github-tag-action@1.52.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        WITH_V: true
        RELEASE_BRANCHES: main
      id: bump
    - name: Create Release
      id: create_release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # This token is provided by Actions, you do not need to create your own token
      with:
        tag_name: ${{ steps.bump.outputs.new_tag }}
        release_name: ${{ steps.bump.outputs.new_tag }}
        body: |
          Changes in this Release
          - Rebuilt Docker image and published to DockerHub with new tag
        draft: false
        prerelease: false
    - name: Publish to Registry
      uses: elgohr/Publish-Docker-Github-Action@master
      with:
        name: missarah/dockerfile-practice # CHANGE THIS to your DockerHub username and repository!
        username: ${{ secrets.DOCKER_USERNAME }} # you need to add your Docker username to this GitHub repo as a secret
        password: ${{ secrets.DOCKER_PASSWORD }} # you need to add your Docker password to this GitHub repo as a secret
        tags: "latest,${{ steps.bump.outputs.new_tag }}"