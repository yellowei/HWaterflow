# HWaterflow

This is a flow layout for UICollectionView.

You can set a array to set a collection view`s layout, this array like that "@[@(3),@(4),@(1)]", these numbers can reflecting structure for your collection view. 

To set layout, you can set two properties:

<div>
        <table border="0">
	  <tr>
	    <th>row</th>
	    <th>col</th>
	  </tr>
	  <tr>
	    <td>rowForSections</td>
	    <td>columnForSections</td>
	  </tr>
	</table>
</div>


```Objective-C
				@property (nonatomic, strong) NSArray * columnForSections;
```
or
```Objective-C
				@property (nonatomic, strong) NSArray * rowForSections;
```
In addiont, you can control the Supplementary Views` heights at the same time.
	
Sorry for my poor English.
