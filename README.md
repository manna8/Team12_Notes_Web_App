# Team12_Notes_Web_App
Web application for the Web System Development subject. Goal of this project is to create webiste that allows users to create notes and group them into collections 

## Authors:
<table>
  <thead>
    <th>Name</th>
    <th>Github</th>
    <th>E-Mail</th>
  </thead>
  <tbody>
    <tr>
      <td>Maja Anna Swierk</td>
      <td><a href="https://github.com/manna8">Manna8</a></td>
      <td><a href="mailto:MajaAnna.Swierk@alu.uclm.es">MajaAnna.Swierk@alu.uclm.es</a></td>
    </tr>
    <tr>
      <td>Jakub Konieczny</td>
      <td><a href="https://github.com/KubaKonieczny">KubaKonieczny</a></td>
      <td><a href="mailto:Jakub.Konieczny@alu.uclm.es">Jakub.Konieczny@alu.uclm.es</a></td>
    </tr>
  </tbody>
</table>

## Technologies 
- Ruby on Rails 7
- Vue.js 3
- MongoDB Atlas 
- Boostrap 5
- CSS

## Development

This prject is develped using TDD in 4 sprints:
- [x] **Sprint 1** Registration and login of users
- [x] **Sprint 2**  Managing the notes
- [ ] **Sprint 3**  Users management
- [ ] **Sprint 4** Friendships and Collections management.


## Running the program
### Running the server
In order to run this program you new to go to server folder and type
```
bundle install
```
and then
```
rails s
```
### Running the client
Go to client folder and type;
```
npm install
```
and then
```
npm run serve
```
## User guide

User guide can be accessible through this link [user guide](https://github.com/manna8/Team12_Notes_Web_App/blob/documentation/MindNote%20-%20user%20guide.pdf)

## Project structure

```
.
├── client
│   ├── config
│   │   └── config.js
│   ├── public
│   │   ├── css
│   │   │   └── main.css
│   │   ├── favicon.ico
│   │   └── index.html
│   └── src
│       ├── assets
│       │   ├── image1.png
│       │   : 
│       │   └── imageN.png
│       ├── components
│       │   ├── component1.png
│       │   : 
│       │   └── componentN.png 
│       ├── services
│       │   └── TokenDataService.js
│       ├── App.vue
│       ├── http-common.js
│       ├── main.js
│       └──  router.js
├── sever
│   ├── app
│   │   ├── assets
│   │   │   └── ...
│   │   ├── controllers
│   │   │   └── ...
│   │   ├── helpers
│   │   │   └── ...
│   │   ├── jobs
│   │   │   └── ...
│   │   ├── mailers
│   │   │   └── ...
│   │   ├── models
│   │   │   └── ...
│   │   └── views
│   │       └── ...
│   ├──  bin
│   │   └── ...
│   ├── config
│   │   └── ...
│   ├── lib
│   │   └── ...
│   ├── log
│   │   └── ...
│   ├── public
│   │   └── ...
│   ├── spec
│   │   └── ...
│   ├── temp
│   │   └── ...
│   ├── vendor
│   │   └── ...
│   ├── Gemfile
│   ├── Rakefile
│   └── config.ru
└── README.md
```

