
<!-- ReadMe -->
<a id="readme-top"></a>

<!-- Opening -->
<br />
<div align="center">
  <a href="https://github.com/WWC-Hackathon-2023/missing_piece_api">
    <img src=".github/the_missing_piece_logo.png" alt="Logo" width="200" height="200">
  </a>

<h3 align="center">Welcome to The Missing Piece</h3>
  <p align="center">
    Add motto here.
    <hr>
    Add short summary here.
  </p>
</div>
<hr>
<br>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#schema">Schema</a></li>
        <li><a href="#testing">Testing</a></li>
      </ul>
    </li>
    <li><a href="#endpoints">Endpoints</a></li>
    <!-- <li><a href="#apis">APIs Used</a></li> -->
    <li><a href="#technologies">Other Technologies Used</a></li>
    <li><a href="#contact">Contributors</a></li>
    <li><a href="#refactor">Future Iterations</a></li>
  </ol>
</details>
<br>

<!-- ABOUT THE PROJECT -->
## About The Project

   💜  [Production Website](add link)
   <br>
   💜  [Backend Service](add link)
   <br>
   💜  [Front End Repository](add link)
   <br>
   <!-- * [Video Presentation]() -->


  **The Missing Piece** was created by an international team of both FrontEnd and BackEnd developers for the **Women Who Code (WWC) Hackathon for Social Good 2023**.(add link)

  The mission of **The Missing Piece** Add details here
  - Challenge Statement
  - Solution Statement

  Users simply....(add overview of how users use the app)


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Built With -->
### Built With

![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white) 
![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white) 
<img src=".github/rspec_badge.jpg" alt="Rspec Badge" height="27">
![Postgresql](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Heroku](https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white)
![AmazonAWS](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)

<!-- ![GoogleCloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![CircleCI](https://img.shields.io/badge/circleci-343434?style=for-the-badge&logo=circleci&logoColor=white)
<img src="https://sendgrid.com/brand/sg-twilio/SG_Twilio_Lockup_RGB-WHT-Textx2.png" height="23"> -->


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

If you'd like to demo this API on your local machine:
1. Ensure you have the prerequisites
2. Clone this repo: `git@github.com:WWC-Hackathon-2023/missing_piece_api.git`
3. Navigate to the root folder: `cd missing_piece_api`
4. Run: `bundle install`
5. Run: `rails db:{create,migrate}`
6. Inspect the `/db/schema.rb` and compare to the 'Schema' section below to ensure migration has been done successfully
7. Run: `rails s`
8. Visit http://localhost:3000/

<!-- Prerequisites -->
### Prerequisites

- Ruby Version 3.1.1
- Rails Version 7.0.4.x
- Bundler Version 2.4.9

<!-- Schema -->
### Schema

<!-- <img src=".github/schema.png" alt="Schema" width="100%"> -->

<!-- Testing -->
### Testing
To test the entire spec suite, run `bundle exec rspec`.
*All tests should be passing.*

Happy path, sad path, and edge testing were considered and tested. When a request cannot be completed, an error object is returned.

<details>
  <summary>Error Object</summary>
    <pre>
    <code>
{
  "errors": [
    {
      "status": "404"
      "title": "Invalid Request",
      "detail": [
        "Couldn't find User with 'id'=<id>"
         ]
     }
   ]
}
    </code>
  </pre>
</details>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Endpoints -->
## Endpoints

<details>
  <summary><code>GET "/api/v1/root"</code></summary>
  Response:
  <pre>
    <code>
      { data }
    </code>
  </pre>
</details>

<details>
  <summary><code>GET "/api/v1/puzzles"</code></summary>
  Request Body:
  <pre>
    <code>
{
  "zip_code": 12345
}
    </code>
  </pre>

  Response:
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>GET "/api/v1/users/:id/puzzles/:id"</code></summary>
  Response:
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>Authorization Page</code></summary>
  Response:
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>GET "/api/v1/users/:id"</code></summary>
  Response:
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>POST "/api/v1/users"</code></summary>
  Request Body:
  <pre>
    <code>
{ data }
    </code>
  </pre>

  Response: 
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>GET "/api/v1/users/:id/loans"</code></summary>
  Response
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>GET "/api/v1/users/:id/puzzles"</code></summary>
  Response:
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>POST "/api/v1/users/:id/puzzles"</code></summary>
  Request Body:
  <pre>
    <code>
{ data }
    </code>
  </pre>

  Response: 
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>PATCH "/api/v1/users/:id/puzzles/:id"</code></summary>
  Request Body:
  <pre>
    <code>
{ data }
    </code>
  </pre>

  Response: 
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>

<details>
  <summary><code>DELETE "/api/v1/users/:id/puzzles/:id"</code></summary>
  Response:
  <pre>
    <code>
{ data }
    </code>
  </pre>
</details>
<br>

View these endpoints in [![Run in Postman](https://run.pstmn.io/button.svg)](Add link here)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- APIs Used 
<h2 id="apis">APIs Used</h2>

[Name](link) was consumed to generate ________

[Name](link) was used to create __________

<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

<!-- Technologies Used -->
<h2 id="technologies">Technologies Used</h2>

[Passage by 1Password](https://passage.1password.com/) was used to authenticate users and ensure login was easy, safe, and quick.

<!-- NOTE: need to add image and more details -->

[Amazon Web Services](https://aws.amazon.com/) was used to allow users to upload photos for their puzzles.

<details>
  <summary><img src= "https://logos-world.net/wp-content/uploads/2021/08/Amazon-Web-Services-AWS-Logo.png" style="width:60px; height:40px;"><strong>Amazon S3 Cloud Object Storage</strong></summary><br>
  <p>By including amazon's web service for storage, we can allow users to upload their pictures which are then saved as objects in a "bucket".  </p>

  More information on the gem used for this(`aws-sdk-s3`) can be found [here](https://github.com/aws/aws-sdk-ruby)
</details>
<br>


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Future Iterations -->

<h2 id="refactor">Future Iterations</h2>
<details>
  <summary>Refactor/Changes</summary>
  <dl>
    <dt>Idea1</dt>
      <dd>- notes</dd>
    <dt>Idea2</dt>
      <dd>- notes</dd>
  </dl>
</details>



<p align="right">(<a href="#readme-top">back to top</a>)</p>

<h2 id="contact">Contributors</h2>


| [<img alt="Paola Andrea Ramirez Quintero" width="75" src=".github/Andrea.jpeg"/>](https://www.linkedin.com/in/paola-andrea-ramirez-quintero/) | [<img alt="Carmen Luna" width="75" src=".github/Carmen.jpg"/>](https://www.linkedin.com/in/carmen-luna-cllp/) | [<img alt="Natalia Torrejon" width="75" src=".github/Nati.jpeg"/>](https://www.linkedin.com/in/natalia-torrejon-developer/) | [<img alt="Kemi Thomas" width="75" src=".github/Kemi.jpeg"/>](https://www.linkedin.com/in/kemi-thomas/) | [<img alt="Bisrat Melak" width="75" src=".github/Bisrat.jpeg"/>](https://www.linkedin.com/in/bisrat-melak/) | [<img alt="Melony Erin Franchini" width="75" src=".github/Melony.jpg"/>](https://www.linkedin.com/in/melony-erin-franchini/) |
| ------------------ | ------------ | -------------- | ----------- | -------------- | ----------- |
| Andrea Ramirez | Carmen Luna | Natalia Torrejon | Kemi Thomas | Bisrat Melak | Melony Erin Franchini |
| FrontEnd | FrontEnd | FrontEnd | FullStack | BackEnd | BackEnd & Team Lead |
| [GitHub](https://github.com/paolandre ) | [GitHub](https://github.com/CarmenLunaP) | [GitHub](https://github.com/Natalia392) | [GitHub](https://github.com/kem247) | [GitHub](https://github.com/bisratlike) | [GitHub](https://github.com/MelTravelz) |
| [LinkedIn](https://www.linkedin.com/in/paola-andrea-ramirez-quintero/) |  [LinkedIn](https://www.linkedin.com/in/carmen-luna-cllp/) | [LinkedIn](https://www.linkedin.com/in/natalia-torrejon-developer/) | [LinkedIn](https://www.linkedin.com/in/kemi-thomas/) | [LinkedIn](https://www.linkedin.com/in/bisrat-melak/) | [LinkedIn](https://www.linkedin.com/in/melony-erin-franchini/) |

<p align="right">(<a href="#readme-top">back to top</a>)</p>
