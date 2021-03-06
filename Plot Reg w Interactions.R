

edu <- sample( 4:22, 200, replace=T )

sex <- sample( 0:1, 200, replace=T ) # male=1

income <- 8000 + 2000*edu + 5000*sex + 800*edu*sex + rnorm(200,0,3000)

palette( c("deeppink","blue") ) 


plot( edu, income, col=factor(sex), pch=19, 
      xlab="Years of Education", ylab="Income" )





mod <- lm( income ~ edu*sex )

summary( mod )

# model coefficients

mod$coefficients



female.int <- mod$coefficients["(Intercept)"]

female.slope <- mod$coefficients["edu"]

abline( a=female.int, b=female.slope, col="deeppink" )



male.int <- mod$coefficients["(Intercept)"] + mod$coefficients["sex"]

male.slope <- mod$coefficients["edu"] + mod$coefficients["edu:sex"]

abline( a=male.int, b=male.slope, col="blue" )