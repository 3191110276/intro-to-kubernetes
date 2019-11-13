# Solution for Challenge 2

This is the solution for the following challenge:

![Challenge 2](../../img/challenge2.png?raw=true "Challenge 2")

This challenge is actually really simple. We only need to change the values for the weights.

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
    - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v2
      weight: 20
    - destination:
        host: reviews
        subset: v3
      weight: 80
```

That's it! You can apply the following command from within the current folder to solve the challenge:

```
kubectl apply -f vs_solution.yaml
```

Awesome!
