# Solution for Challenge 1

This is the solution for the following challenge:

![Challenge 1](../../img/challenge1.png?raw=true "Challenge 1")

Achieving this is actually quite simple.  We already have all the Istio Destination Rules set up, so we just have to adjust the Istio Virtual Service. We will exchange 'v1' with 'v2' and we are good to go.

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
```

You can apply this by running the following command from within the current directory:

```
kubectl apply -f virtualservice_v2.yaml
```
