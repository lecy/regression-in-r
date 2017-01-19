# Regression coefficient plots

From [Thomas Leeper](http://thomasleeper.com/Rcourse/Tutorials/olscoefplot.html).

A contemporary way of presenting regression results involves converting a regression table into a figure.

```r
    set.seed(500)
    x1 <- rnorm(100, 5, 5)
    x2 <- rnorm(100, -2, 10)
    x3 <- rnorm(100, 0, 20)
    y <- (1 * x1) + (-2 * x2) + (3 * x3) + rnorm(100, 0, 20)
    ols2 <- lm(y ~ x1 + x2 + x3)
```

Conventionally, we would present results from this regression as a table:

```r
    summary(ols2)

    ## 
    ## Call:
    ## lm(formula = y ~ x1 + x2 + x3)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -53.89 -12.52   2.67  11.24  46.85 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  -0.0648     2.6053   -0.02    0.980    
    ## x1            1.2211     0.3607    3.39    0.001 ** 
    ## x2           -2.0941     0.1831  -11.44   <2e-16 ***
    ## x3            3.0086     0.1006   29.90   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 19.1 on 96 degrees of freedom
    ## Multiple R-squared:  0.913,  Adjusted R-squared:  0.91 
    ## F-statistic:  335 on 3 and 96 DF,  p-value: <2e-16

```


Or just:

```r
    coef(summary(ols2))[, 1:2]

    ##             Estimate Std. Error
    ## (Intercept) -0.06483     2.6053
    ## x1           1.22113     0.3607
    ## x2          -2.09407     0.1831
    ## x3           3.00856     0.1006

```

It might be helpful to see the size and significance of these effects as a figure. To do so, we have to draw the regression slopes as points and the SEs as lines.

```r
    slopes <- coef(summary(ols2))[c("x1", "x2", "x3"), 1]  #' slopes
    ses <- coef(summary(ols2))[c("x1", "x2", "x3"), 2]  #' SEs
```


We'll draw the slopes of the three input variables. Note: The interpretation of the following plot depends on input variables that have comparable scales. Note (continued): Comparing dissimilar variables with this visualization can be misleading!

## Plotting Standard Errors

Let's construct a plot that draws 1 and 2 SEs for each coefficient:

We'll start with a blank plot (like a blank canvas):

```r
    plot(NA, xlim = c(-3, 3), ylim = c(0, 4), xlab = "Slope", ylab = "", yaxt = "n")
    # We can add a title:
    title("Regression Results")
    # We'll add a y-axis labelling our variables:
    axis(2, 1:3, c("x1", "x2", "x3"), las = 2)
    # We'll add a vertical line for zero:
    abline(v = 0, col = "gray")
    # Then we'll draw our slopes as points (`pch` tells us what type of point):
    points(slopes, 1:3, pch = 23, col = "black", bg = "black")
    # Then we'll add thick line segments for each 1 SE:
    segments((slopes - ses)[1], 1, (slopes + ses)[1], 1, col = "black", lwd = 2)
    segments((slopes - ses)[2], 2, (slopes + ses)[2], 2, col = "black", lwd = 2)
    segments((slopes - ses)[3], 3, (slopes + ses)[3], 3, col = "black", lwd = 2)
    # Then we'll add thin line segments for the 2 SEs:
    segments((slopes - (2 * ses))[1], 1, (slopes + (2 * ses))[1], 1, col = "black", 
        lwd = 1)
    segments((slopes - (2 * ses))[2], 2, (slopes + (2 * ses))[2], 2, col = "black", 
        lwd = 1)
    segments((slopes - (2 * ses))[3], 3, (slopes + (2 * ses))[3], 3, col = "black", 
        lwd = 1)
```


![plot of chunk unnamed-chunk-5](./images/img1.png)



## Plotting Confidence Intervals

We can draw a similar plot with confidence intervals instead of SEs.


```r
    plot(NA, xlim = c(-3, 3), ylim = c(0, 4), xlab = "Slope", ylab = "", yaxt = "n")
    title("Regression Results")
    axis(2, 1:3, c("x1", "x2", "x3"), las = 2)
    abline(v = 0, col = "gray")
    points(slopes, 1:3, pch = 23, col = "black", bg = "black")
    # Then we'll add thick line segments for each 67% CI: Note: The `qnorm`
    # function tells us how much to multiple our SEs by to get Gaussian CIs.
    # Note: We'll also use vectorization here to save having to retype the
    # `segments` command for each line:
    segments((slopes - (qnorm(0.835) * ses)), 1:3, (slopes + (qnorm(0.835) * ses)), 
        1:3, col = "black", lwd = 3)
    # Then we'll add medium line segments for the 95%:
    segments((slopes - (qnorm(0.975) * ses)), 1:3, (slopes + (qnorm(0.975) * ses)), 
        1:3, col = "black", lwd = 2)
    # Then we'll add thin line segments for the 99%:
    segments((slopes - (qnorm(0.995) * ses)), 1:3, (slopes + (qnorm(0.995) * ses)), 
        1:3, col = "black", lwd = 1)
```



![plot of chunk unnamed-chunk-6](./images/img2.png)



Both of these plots are similar, but show how the size, relative size, and significance of regression slopes can easily be summarized visually.

Note: We can also extract confidence intervals for our model terms directly using the `confint` function applied to our modle object and then plot those CIs using `segments`:

```r
    ci67 <- confint(ols2, c("x1", "x2", "x3"), level = 0.67)
    ci95 <- confint(ols2, c("x1", "x2", "x3"), level = 0.95)
    ci99 <- confint(ols2, c("x1", "x2", "x3"), level = 0.99)
```



Now draw the plot:

```r
    plot(NA, xlim = c(-3, 3), ylim = c(0, 4), xlab = "Slope", ylab = "", yaxt = "n")
    title("Regression Results")
    axis(2, 1:3, c("x1", "x2", "x3"), las = 2)
    abline(v = 0, col = "gray")
    points(slopes, 1:3, pch = 23, col = "black", bg = "black")
    # add the confidence intervals:
    segments(ci67[, 1], 1:3, ci67[, 2], 1:3, col = "black", lwd = 3)
    segments(ci95[, 1], 1:3, ci95[, 2], 1:3, col = "black", lwd = 2)
    segments(ci99[, 1], 1:3, ci99[, 2], 1:3, col = "black", lwd = 1)
```


![plot of chunk unnamed-chunk-8](./images/img3.png)

## Comparable effect sizes

One of the major problems (noted above) with these kinds of plots is that in order for them to make visual sense, the underlying covariates have to be inherently comparable. By showing slopes, the plot shows the effect of a unit change in each covariate on the outcome, but unit changes may not be comparable across variables. We could probably come up with an infinite number of ways of presenting the results, but let's focus on two here: plotting standard deviation changes in covariates and plotting minimum to maximum changes in scale of covariates.

### Standard deviation changes in X

Let's recall the values of our coefficients on `x1`, `x2`, and `x3`:

```
    coef(summary(ols2))[, 1:2]

    ##             Estimate Std. Error
    ## (Intercept) -0.06483     2.6053
    ## x1           1.22113     0.3607
    ## x2          -2.09407     0.1831
    ## x3           3.00856     0.1006

```

On face value, `x3` has the largest effect, but what happens when we account for different standard deviations of the covariates:

```
    sd(x1)

    ## [1] 5.311

    sd(x2)

    ## [1] 10.48

    sd(x3)

    ## [1] 19.07

```

`x1` clearly also has the largest variance, so it may make more sense to compare a standard deviation change across the variables. To do that is relatively simple because we're working in a linear model, so we simply need to calculate the standard deviation of each covariate and multiply that by the respective coefficient:

```r
    c1 <- coef(summary(ols2))[-1, 1:2]  # drop the intercept
    c2 <- numeric(length = 3)
    c2[1] <- c1[1, 1] * sd(x1)
    c2[2] <- c1[2, 1] * sd(x2)
    c2[3] <- c1[3, 1] * sd(x3)
```


Then we'll get standard errors for those changes:

```r
    s2 <- numeric(length = 3)
    s2[1] <- c1[1, 2] * sd(x1)
    s2[2] <- c1[2, 2] * sd(x2)
    s2[3] <- c1[3, 2] * sd(x3)

```

Then we can plot the results:

```r
    plot(c2, 1:3, pch = 23, col = "black", bg = "black", xlim = c(-25, 65), ylim = c(0, 
        4), xlab = "Slope", ylab = "", yaxt = "n")
    title("Regression Results")
    axis(2, 1:3, c("x1", "x2", "x3"), las = 2)
    abline(v = 0, col = "gray")
    # Then we'll add medium line segments for the 95%:
    segments((c2 - (qnorm(0.975) * s2)), 1:3, (c2 + (qnorm(0.975) * s2)), 1:3, col = "black", 
        lwd = 2)
    # Then we'll add thin line segments for the 99%:
    segments((c2 - (qnorm(0.995) * s2)), 1:3, (c2 + (qnorm(0.995) * s2)), 1:3, col = "black", 
        lwd = 1)
```



![plot of chunk unnamed-chunk-13](./images/img4.png)




By looking at standard deviation changes (focus on the scale of the x-axis), we can see that `x3` actually has the largest effect by a much larger factor than we saw in the raw slopes. Moving the same relative amount up each covariate's distribution produces substantially different effects on the outcome.





### Full scale changes in X

Another way to visualize effect sizes is to examine the effect of full scale changes in covariates. This is especially useful when deal within covariates that differ dramatically in scale (e.g., a mix of discrete and continuous variables). The basic calculations for these kinds of plots are the same as in the previous plot, but instead of using `sd`, we use `diff(range())`, which tells us what a full scale change is in the units of each covariate:

```r

    c3 <- numeric(length = 3)
    c3[1] <- c1[1, 1] * diff(range(x1))
    c3[2] <- c1[2, 1] * diff(range(x2))
    c3[3] <- c1[3, 1] * diff(range(x3))

```




Then we'll get standard errors for those changes:

```r
    s3 <- numeric(length = 3)
    s3[1] <- c1[1, 2] * diff(range(x1))
    s3[2] <- c1[2, 2] * diff(range(x2))
    s3[3] <- c1[3, 2] * diff(range(x3))

```



Then we can plot the results:

```r
    plot(c3, 1:3, pch = 23, col = "black", bg = "black", xlim = c(-150, 300), ylim = c(0, 
        4), xlab = "Slope", ylab = "", yaxt = "n")
    title("Regression Results")
    axis(2, 1:3, c("x1", "x2", "x3"), las = 2)
    abline(v = 0, col = "gray")
    # Then we'll add medium line segments for the 95%:
    segments((c3 - (qnorm(0.975) * s3)), 1:3, (c3 + (qnorm(0.975) * s3)), 1:3, col = "black", 
        lwd = 2)
    # Then we'll add thin line segments for the 99%:
    segments((c3 - (qnorm(0.995) * s3)), 1:3, (c3 + (qnorm(0.995) * s3)), 1:3, col = "black", 
        lwd = 1)
```


![plot of chunk unnamed-chunk-16](./images/img5.png)




Focusing on the x-axes of the last three plots, we see how differences in scaling of the covariates can lead to vastly different visual interpretations of effect sizes. Plotting the slopes directly suggested that `x3` had an effect about three times larger than the effect of `x1`. Plotting standard deviation changes suggested that `x3` had an effect about 10 times larger than the effect of `x1` and plotting full scale changes in covariates showed a similar substantive conclusion. While each showed that `x3` had the largest effect, interpreting the relative contribution of the different variables depends upon how much variance we would typically see in each variable in our data. The unit-change effect (represented by the slope) may not be the effect size that we ultimately care about for each covariate.
