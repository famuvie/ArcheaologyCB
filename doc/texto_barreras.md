## Limitaciones de métodos ordinarios de interpolación espacial

Todos los métodos (tanto los deterministas: Inverse Distance Weighting, Nearest Neighbours, Thin Plate Splines, etc. como los geoestadísticos, i.e. las diversas variantes del Kriging) vinculan dos localizaciones cualesquiera, de una manera u otra, en términos de la distancia Euclídea que las separa (i.e. en línea recta). 
Esto tiene sentido cuando la región es homogénea, es decir, no hay obstáculos o irregularidades que distorsionen el fenómeno bajo estudio.
Técnicamente se dice que el proceso es *estacionario*.

Se trata de una hipótesis que raramente se cumple en problemas mediambientales, pero que es conveniente desde el punto de vista computacional y a menudo resulta una aproximación suficientemente buena.
Cuando existen elementos geográficos que actúan como barreras sólidas o semisólidas, limitando sustancialmente la continuidad del proceso, es necesario tomar en cuenta esta falta de estacionariedad mediante métodos específicos.


## Métodos adaptados a la geografía

No hay un método universal para modelar este tipo de situaciones. En cambio, se han adoptado diferentes enfoques bastante *ad-hoc* que intentan explotar características propias de problemas determinados.
Por ejemplo, el análisis de fenómenos que tienen lugar en ríos o redes de ríos, canales, estuarios, etc. es un campo que típicamente presenta este tipo de dificultades y desde el que se ha contribuido mucho al desarrollo de soluciones (véase por ejemplo, Cressie et al. 2006; Ver-Hoef and Peterson, 2010).
Sin embargo, muchas de estas soluciones modelan los ríos como redes unidimensionales, lo que hace imposible adaptar las metodologías a otras situaciones más generales.

Igual que ocurre con los métodos de interpolación regulares, existen métodos tanto deterministas como geoestadísticos para tener en cuenta las particularidades geográficas.

Entre los deterministas podemos destacar el método *Soap film smoothing* (Wood et al., 2008). Un método de suavizado espacial que responde a la forma que adoptaría una película de jabón sometida a unos límites fijos. Es particularmente atractivo cuando se tienen unas condiciones de borde conocidas.

Mientras que los métodos deterministas son muy últiles para un análisis exploratorio de los datos, los modelos geoestadísticos permiten valorar el error de predicción.
Muchos métodos se basan en una aproximación Euclideana (típicamente en una dimensión mayor, utilizando Multidimensional Scaling) del problema no-Euclídeo (e.g. Løland and Høst, 2003; Boisvert et al. 2009). 
Sin embargo, lo que nos interesa es precisamente modelar las irregularidades que hacen el problema no-Euclídeo, en lugar de *suavizarlas* para poder tratarlo como un problema Euclideano.

Otros, en cambio, incorporan en el modelo directamente una distancia no-Euclídea, que depende de la geografía del terreno (e.g. Rathbun, 1998), aunque sólo admiten barreras absolutas en una región por lo demás homogénea.
La metodología propuesta por López-Quíles y Muñoz (2009) es una generalización que permite modelar todo tipo de heterogeneidades incluyendo barreras sólidas o semisólidas y variaciones continuas de la *permeabilidad* del terreno. De esta manera, las características geográficas se traducen en una *superficie de coste* de donde se derivan sendas distancias no-Euclídeas *basadas en el coste*, que son las que se utilizan en la modelización geoestadística.




## Bibliografía

Boisvert, J. B., Manchuk, J. G., and Deutsch, C. V. (2009). Kriging in the presence of locally varying anisotropy using Non-Euclidean distances. Mathematical Geosciences, 41(5):585-601.

Cressie, N., Frey, J., Harch, B., and Smith, M. (2006). Spatial prediction on a river network. Journal of Agricultural, Biological, and Environmental Statistics, 11(2):127-150.

Løland, A. and Høst, G. (2003). Spatial covariance modelling in a complex coastal domain by multidimensional scaling. Environmetrics, 14(3):307-321.

López-Quílez, A. and Muñoz, F. (2009). Geostatistical computing of acoustic maps in the presence of barriers. Mathematical and Computer Modelling, 50(5-6):929-938.

Rathbun, S. L. (1998). Spatial modelling in irregularly shaped regions: Kriging estuaries. Environmetrics, 9:109-129.

Ver-Hoef, J. M. and Peterson, E. E. (2010). A moving average approach for spatial statistical models of stream networks. Journal of the American Statistical Association, 105(489):6-18.

Wood, S. N., Bravington, M. V., and Hedley, S. L. (2008). Soap film smoothing. Journal of the Royal Statistical Society: Series B (Statistical Methodology), 70(5):931-955.

