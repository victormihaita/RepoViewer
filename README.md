# RepoViewer
iOS Application that displays the Git repositories of the user/organization. 

![screenshot](https://imgur.com/a/tJxSo3y)
![screenshot](https://imgur.com/a/rCherEn)
![screenshot](https://imgur.com/a/B2OB6cU)

### Features
* View with a list of repositories for the user/organization
  - Repositories on the list view are be grouped into sections by programming language
  - Sections are sorted by language with most to least repos in descending order
  - Repositories within each section are sorted by most starred in descending
  - Repository live search

*  Detail view with extra information about the repository

#### Pods used
- pod 'Apollo'
- pod 'ApolloAlamofire'
- pod 'OAuthSwift'
- pod 'RxCocoa'
- pod 'RxSwift'

## Clone the Repo 
`git clone https://github.com/victormihaita/RepoViewer.git`

## Install Pods 
`pod install`

## Open Project in Xcode
`RepoViewer.xcworkspace`
