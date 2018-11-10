# RepoViewer
iOS Application that displays the Git repositories of the user/organization. 

![screenshot](https://github.com/victormihaita/RepoViewer/blob/develop/Screenshot%202018-11-10%20at%2000.23.10.jpg)
![screenshot](https://github.com/victormihaita/RepoViewer/blob/develop/Screenshot%202018-11-10%20at%2000.23.47.jpg)
![screenshot](https://github.com/victormihaita/RepoViewer/blob/develop/Screenshot%202018-11-10%20at%2000.24.25.jpg)

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
